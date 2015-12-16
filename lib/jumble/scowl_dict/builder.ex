defmodule Jumble.ScowlDict.Builder do
  alias IO.ANSI
  alias Jumble.Helper
  alias Jumble.Ticker
  alias Jumble.LengthDict.Builder
  alias Jumble.ScowlDict.Builder.FileBuilder

  @dict_sizes   Application.get_env(:jumble, :scowl_dict_sizes)
  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @final_dir    Path.join(@scowl_dir, "final")
  
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^a-z\n].*\n/m

  @prompt_rcap "/* >" <> ANSI.normal
  @prompt_lcap ANSI.yellow
    |> Helper.cap(ANSI.bright, "\n< BUILDING scowl_dict/size_")

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
    FileBuilder.clear_files

    @dict_sizes
    |> Enum.reduce(Map.new, fn(dict_size, scowl_dict)->
      dict_size
      |> Helper.cap(@prompt_lcap, @prompt_rcap)
      |> IO.puts

      Ticker.start

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
      |> FileBuilder.build_files(dict_size)
    end)
  end
end