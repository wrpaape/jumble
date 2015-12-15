defmodule Jumble.ScowlDict.Size50.Length19 do
  def get(string_id) do
    %{"aaccdeeghilooprrrst" => ["electrocardiographs"],
      "aadeeiiilmnnnnoortt" => ["interdenominational"],
      "aaeeeilnnnnooprrstt" => ["nonrepresentational"],
      "abccfhllnooooorrrsu" => ["chlorofluorocarbons"],
      "acefiiiilmnooprsstv" => ["oversimplifications"],
      "cceeeegiillnnnorttu" => ["counterintelligence"]}
    |> Map.get(string_id)
  end
end
