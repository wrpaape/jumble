defmodule LengthDict.Builder do
  alias Jumble.Helper
  # "/Users/Reid/my_projects/babby_elixir/scramble/jumble/lib/dictionary"

  def build do
    File.read!("/usr/share/dict/words")
    |> String.split
    |> Enum.group_by(&String.length/1)
    |> Enum.each(fn({length, words}) ->
      length_string =
        length
        |> Integer.to_string

      string_id_map = 
        words
        |> Enum.group_by(&Helper.string_id)
        |> inspect

      module_attr =
        length_string
        |> Helper.cap("@length_", "_length_dict")

      contents =
      """
      defmodule LengthDict.Length#{length}
        #{module_attr} #{string_id_map}
        
        def get(string_id) do
          #{module_attr}
          |> Map.get(string_id)
        end
      end
      """

      length
      |> Helper.cap("length_", ".ex")
      |> File.write(contents)
    end)
  end
end
