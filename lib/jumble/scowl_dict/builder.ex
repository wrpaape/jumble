defmodule Jumble.ScowlDict.Builder do
  alias Jumble.Helper
  alias Jumble.LengthDict.Builder

  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @final_dir    Path.join(@scowl_dir, "final")
  @dir          Application.get_env(:jumble, :scowl_dict_dir)
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^a-z\n].*\n/m
  @indent       Helper.pad(4)
  @dict_sizes   Application.get_env(:jumble, :scowl_dict_sizes)

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

    @dict_sizes
    |> Enum.reduce(Map.new, fn(dict_size, scowl_dict)->
      dict_size
      |> filtered_word_list
      |> Enum.group_by(&byte_size/1)
      |> Enum.reduce(scowl_dict, fn({length, words}, scowl_dict)->
        words
        |> Enum.group_by(&Helper.string_id/1)
        |> Enum.reduce(scowl_dict, fn({string_id, words}, scowl_dict)->
          scowl_dict
          |> Map.update(Integer.to_string(length), Map.put(Map.new, string_id, words), fn(length_dict)->
            length_dict
            |> Map.update(string_id, words, &(words ++ &1))
          end)
        end)
      end)
      |> build_files(dict_size)
    end)
  end

  def dict_dir(dict_size), do: Path.join(@dir, "size_" <> dict_size)

  defp format(data) do
    data
    |> inspect(pretty: :true, limit: :infinity)
    |> String.replace(~r/(?<=\n)/, @indent)
  end

  def build_files(scowl_dict, dict_size) do
    dict_dir =
      dict_size
      |> dict_dir

    scowl_dict
    |> Enum.each(fn({length_string, string_ids_map})->
      printed_map =
        string_ids_map
        |> format

      printed_keys =
        string_ids_map
        |> Map.keys
        |> format

      contents =
        """
        defmodule Jumble.ScowlDict.Size#{dict_size}.Length#{length_string} do
          def get(string_id) do
            #{printed_map}
            |> Map.get(string_id)
          end

          def valid_ids do
            #{printed_keys}
            |> Enum.into(HashSet.new)
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
    @dict_sizes
    |> Enum.each(fn(dict_size)->
      dict_size
      |> dict_dir
      |> Path.join("**")
      |> Path.wildcard
      |> File.rm_rf
    end)
  end
end