defmodule Jumble.ScowlDict.Builder do
  alias Jumble.Helper
  alias Jumble.LengthDict.Builder

  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @final_dir    Path.join(@scowl_dir, "final")
  @dir          Application.get_env(:jumble, :scowl_dict_dir)
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^a-z\n].*\n/m
  @indent       Helper.pad(4)
  @filenames    Enum.map(~w(95 80 70 60 55 50 40 35 20 10), &("english-words." <> &1))
  @size_dirs    ~w(small medium large)
  @dict_sizes   @dict_dirs
    |> Enum.reduce({Map.new, [1, 2, length(@filenames)]}, fn(dir, {size_map, [next_take_count | rem_take_counts]})->
      size_map
      |> Map.put(Path.join(@dir, size_dir), {String.capitalize(size_dir), next_take_count})
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

  def build_file({length_string, string_ids_map})do
    @dict_sizes
    |> Enum.each(fn({dir, {size_module, take_count}})->


    end)
    printed_map =
      string_ids_map
      |> inspect(pretty: :true, limit: :infinity)
      |> String.replace(~r/(?<=\n)/, @indent)

    contents =
      """
      defmodule Jumble.ScowlDict.#{dict_size}.Length#{length_string} do
        def get(string_id) do
          #{printed_map}
          |> Map.get(string_id)
        end
      end
      """

    length_string
    |> Helper.cap("length_", ".ex")
    |> Path.expand(@dir)
    |> File.write(contents)
  end

  def clean do
    @
    Path.join(@dir, "length_*.ex")
    |> Path.wildcard
    |> Enum.each(&File.rm_rf/1)
  end
end