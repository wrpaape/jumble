defmodule Jumble.ScowlDict.Builder.FileBuilder do
  alias IO.ANSI
  alias Jumble.Helper
  alias Jumble.Ticker

  @dir          Application.get_env(:jumble, :scowl_dict_dir)
  @indent       Helper.pad(4)
  @clear_prompt "< CLEARING scowl_dict/** >"
    |> Helper.cap(ANSI.bright <> ANSI.red, ANSI.normal)

  def size_dir(dict_size), do: Path.join(@dir, "size_" <> dict_size)

  defp format(data) do
    data
    |> inspect(pretty: :true, limit: :infinity)
    |> String.replace(~r/(?<=\n)/, @indent)
  end

  defp dict_module(dict_size, length_string) do
    ".Length"
    |> Helper.cap(dict_size, length_string)
    |> Helper.cap("Jumble.ScowlDict.Size", ".Dict")
  end

  def clear_files do
    @clear_prompt
    |> IO.puts

    Ticker.start

      @dir
      |> Path.join("size_*")
      |> Path.wildcard
      |> Enum.each(&File.rm_rf!/1)

    Ticker.stop
  end

  def build_files(scowl_dict, dict_size) do
    size_dir =
      dict_size
      |> size_dir

    size_dir
    |> File.mkdir!

    scowl_dict
    |> Enum.each(fn({length_string, string_ids_map})->
      printed_map =
        string_ids_map
        |> format

      dict_module = 
        dict_size
        |> dict_module(length_string)

      server_contents =
        """
        import Jumble.ScowlDict.Builder.ServerBuilder

        build_server(#{dict_size}, #{length_string})
        """

      dict_contents =
        """
        defmodule #{dict_module} do
          def get do
            #{printed_map}
          end
        end
        """

      server_path =
        length_string
        |> Helper.cap("length_", ".ex")
        |> Path.expand(size_dir)

      server_path
      |> File.write!(server_contents)

      dict_dir =
        server_path
        |> Path.rootname(".ex")

      dict_dir
      |> File.mkdir!

      dict_dir
      |> Path.join("dict.ex")
      |> File.write!(dict_contents)
    end)

    Ticker.stop

    scowl_dict
  end
end