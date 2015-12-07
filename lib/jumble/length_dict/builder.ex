defmodule Jumble.LengthDict.Builder do
  alias Jumble.Helper

  @dict_path Application.get_env(:jumble, :dict_path)
  @dir       Application.get_env(:jumble, :length_dict_dir)
  @indent    String.duplicate(" ", 4)

  def build do
    @dict_path
    |>File.read!
    |> String.split
    |> Enum.group_by(&String.length/1)
    |> Enum.each(fn({length, words}) ->
      length_string =
        length
        |> Integer.to_string

      string_id_map = 
        words
        |> Enum.group_by(&Helper.string_id/1)
        |> inspect(pretty: :true, limit: :infinity)
        |> String.replace(~r/(?<=\n)/, @indent)

      contents =
        """
        defmodule Jumble.LengthDict.Length#{length} do
          def get(string_id) do
            #{string_id_map}
            |> Map.get(string_id)
          end
        end
        """

      length_string
      |> Helper.cap("length_", ".ex")
      |> Path.expand(@dir)
      |> File.write(contents)
    end)
  end
end
