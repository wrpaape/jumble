defmodule LengthDict.Builder do
  @dict_path Application.get_env(:jumble, :dict_path)
  @dir       Application.get_env(:jumble, :length_dict_dir)

  alias Jumble.Helper

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
        |> inspect

      module_attr =
        length_string
        |> Helper.cap("@length_", "_length_dict")

      contents =
        """
        defmodule LengthDict.Length#{length} do
          #{module_attr} #{string_id_map}
          
          def get(string_id) do
            #{module_attr}
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
