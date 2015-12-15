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

  def valid_ids do
    ["aaccdeeghilooprrrst", "aadeeiiilmnnnnoortt", "aaeeeilnnnnooprrstt",
     "abccfhllnooooorrrsu", "acefiiiilmnooprsstv", "cceeeegiillnnnorttu"]
    |> Enum.into(HashSet.new)
  end
end
