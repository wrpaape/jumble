defmodule Jumble.ScowlDict.Builder do
  alias Jumble.Helper
  alias Jumble.LengthDict.Builder

  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @final_dir    Path.join(@scowl_dir, "final")
  @dir          Application.get_env(:jumble, :scowl_dict_dir)
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^a-z\n].*\n/m
  @indent       Helper.pad(4)
  # @filenames    Enum.map(~w(95 80 70 60 55 50 40 35 20 10), &("english-words." <> &1))
  @filenames    Enum.map(~w(10 20 35 40 50 55 60 70 80 95), &("english-words." <> &1))
  # @dict_sizes   [

  @size_specs   [{"small", [10 20 35]}, "medium" large)
    |> Enum.reduce({Map.new, [{3, 1, 2, length(@filenames)]}, fn(size, {size_map, [next_take_count | rem_take_counts]})->
      size_map
      |> Map.put(Path.join(@dir, size), {String.capitalize(size), next_take_count})
      |> Helper.wrap_append(rem_take_counts)
    end)
    |> elem(0)

  def build_length_dict do
    @scowl_dir
    |> Path.join("mk-list")
    |> System.cmd(@mk_list_opts, cd: @scowl_dir)
    |> elem(0)
    |> String.replace(@reg_filter, "")
    |> String.downcase
    |> String.split
    |> Enum.uniq
    |> Builder.build
  end


  def build do
    clean

    @filenames
    |> Enum.reduce(Map.new, fn(filename, lengths_map)->
      @final_dir
      |> Path.join(filename)
      |> File.read!
      |> String.replace(@reg_filter, "")
      |> String.split
      |> Enum.group_by(fn(word)->
        word
        |> byte_size
        |> Integer.to_string
      end)
      |> Enum.reduce(lengths_map, fn({length, words}, lengths_map)->
        words
        |> Enum.group_by(&Helper.string_id/1)
        |> Enum.reduce(lengths_map, fn({string_id, words}, lengths_map)->
          lengths_map
          |> Map.update(length, Map.put(Map.new, string_id, [words]), fn(string_ids_map)->
            string_ids_map
            |> Map.update(string_id, [words], fn(words_list)->
              [words | words_list]
            end)
          end)
        end)
      end)
    end)
    |> Enum.each(&build_file/1)
  end

  def build_dict_map(string_ids_map, take_count) do
    string_ids_map
    |> Enum.reduce(Map.new, fn({string_id, words_list}, next_map)->
      next_words =
        words_list
        |> Enum.take(take_count)
        |> List.flatten

      next_map
      |> Map.put(string_id, next_words)
    end)
  end

  def build_file({length_string, string_ids_map})do
    @size_specs
    |> Enum.each(fn({size_dir, {size_module, take_count}})->
      printed_map =
        string_ids_map
        |> build_dict_map(take_count)
        |> inspect(pretty: :true, limit: :infinity)
        |> String.replace(~r/(?<=\n)/, @indent)

      contents =
        """
        defmodule Jumble.ScowlDict.#{size_module}.Length#{length_string} do
          def get(string_id) do
            #{printed_map}
            |> Map.get(string_id)
          end
        end
        """

      length_string
      |> Helper.cap("length_", ".ex")
      |> Path.expand(size_dir)
      |> File.write(contents)
    end)
  end

  def clean do
    @size_specs
    |> Enum.each(fn({dir, _})->
      dir
      |> Path.join("**")
      |> Path.wildcard
      |> File.rm_rf
    end)
  end
end