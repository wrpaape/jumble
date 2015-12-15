defmodule Jumble.ScowlDict.Builder do
  alias Jumble.Helper
  alias Jumble.LengthDict.Builder

  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @final_dir    Path.join(@scowl_dir, "final")
  @dir          Application.get_env(:jumble, :scowl_dict_dir)
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^a-z\n].*\n/m
  @indent       Helper.pad(4)
  @size_specs   [{"small", ~w(10 20 35)}, {"medium", ~w(40 50 55)}, {"large", ~w(60 70 80 95)}]

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

  def filtered_word_list(size) do
    @final_dir
    |> Path.join("english-words." <> size)
    |> File.read!
    |> String.replace(@reg_filter, "")
    |> String.split
  end

  def build do
    clean

    @size_specs
    |> Enum.reduce(Map.new, fn({dict_size, scowl_sizes}, scowl_dict)->
      scowl_sizes
      |> Enum.reduce(scowl_dict, fn(scowl_size, scowl_dict)->
        scowl_size
        |> filtered_word_list
        |> Enum.group_by(&byte_size/1)
        |> Enum.reduce(scowl_dict, fn({length, words}, scowl_dict)->
          words
          |> Enum.group_by(&Helper.string_id/1)
          |> Enum.reduce(scowl_dict, fn({string_id, words}, scowl_dict)->
            scowl_dict
            |> Map.update(Integer.to_string(length), Map.put(Map.new, string_id, words), fn(string_ids_map)->
              string_ids_map
              |> Map.update(string_id, words, fn(acc_words)->
                words ++ acc_words
              end)
            end)
          end)
        end)
      end)
      |> build_files(dict_size)
    end)
  end

  def dict_dir(dict_size), do: Path.join(@dir, dict_size)

  def build_files(scowl_dict, dict_size) do
    dict_dir =
      dict_size
      |> dict_dir

    scowl_dict
    |> Enum.each(fn({length_string, string_ids_map})->
      printed_map =
        string_ids_map
        |> inspect(pretty: :true, limit: :infinity)
        |> String.replace(~r/(?<=\n)/, @indent)

      contents =
        """
        defmodule Jumble.ScowlDict.#{String.capitalize(dict_size)}.Length#{length_string} do
          def get(string_id) do
            #{printed_map}
            |> Map.get(string_id)
          end
        end
        """

      length_string
      |> Helper.cap("length_", ".ex")
      |> Path.expand(dict_dir)
      |> File.write(contents)
    end)

    scowl_dict
  end

  def clean do
    @size_specs
    |> Enum.each(fn({dict_size, _})->
      dict_size
      |> dict_dir
      |> Path.join("**")
      |> Path.wildcard
      |> File.rm_rf
    end)
  end
end
  # def build_dict_map(string_ids_map, take_count) do
  #   string_ids_map
  #   |> Enum.reduce(Map.new, fn({string_id, words_list}, next_map)->
  #     next_words =
  #       words_list
  #       |> Enum.take(take_count)
  #       |> List.flatten

  #     next_map
  #     |> Map.put(string_id, next_words)
  #   end)
  # end
  # def build do
  #   clean

  #   @filenames
  #   |> Enum.reduce(Map.new, fn(filename, lengths_map)->
  #     @final_dir
  #     |> Path.join(filename)
  #     |> File.read!
  #     |> String.replace(@reg_filter, "")
  #     |> String.split
  #     |> Enum.group_by(fn(word)->
  #       word
  #       |> byte_size
  #       |> Integer.to_string
  #     end)
  #     |> Enum.reduce(lengths_map, fn({length, words}, lengths_map)->
  #       words
  #       |> Enum.group_by(&Helper.string_id/1)
  #       |> Enum.reduce(lengths_map, fn({string_id, words}, lengths_map)->
  #         lengths_map
  #         |> Map.update(length, Map.put(Map.new, string_id, [words]), fn(string_ids_map)->
  #           string_ids_map
  #           |> Map.update(string_id, [words], fn(words_list)->
  #             [words | words_list]
  #           end)
  #         end)
  #       end)
  #     end)
  #   end)
  #   |> Enum.each(&build_file/1)
  # end