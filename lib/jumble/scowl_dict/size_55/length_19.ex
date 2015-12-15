defmodule Jumble.ScowlDict.Size55.Length19 do
  def get(string_id) do
    %{"aaccdeeghilooprrrst" => ["electrocardiographs"],
      "aacddiiiiilllnstuvy" => ["individualistically"],
      "aadeeiiilmnnnnoortt" => ["interdenominational"],
      "aadefghinorrrsssttw" => ["straightforwardness"],
      "aaeeeilnnnnooprrstt" => ["nonrepresentational"],
      "abccfhllnooooorrrsu" => ["chlorofluorocarbons"],
      "acefiiiilmnooprsstv" => ["oversimplifications"],
      "bceehiiiilmnnoprsty" => ["incomprehensibility"],
      "cceeeegiillnnnorttu" => ["counterintelligence"]}
    |> Map.get(string_id)
  end
end
