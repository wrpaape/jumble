defmodule Jumble.ScowlDict.Size60.Length19 do
  def get(string_id) do
    %{"aaccdeeghilooprrrst" => ["electrocardiographs"],
      "aaccdeeghilooprrrty" => ["electrocardiography"],
      "aacceeegilllmnortty" => ["electromagnetically"],
      "aacddiiiiilllnstuvy" => ["individualistically"],
      "aachhillmnooopprrty" => ["anthropomorphically"],
      "aadeeiiilmnnnnoortt" => ["interdenominational"],
      "aadefghinorrrsssttw" => ["straightforwardness"],
      "aaeeeilnnnnooprrstt" => ["nonrepresentational"],
      "aaeeiiilorrrrttttxy" => ["extraterritoriality"],
      "abccfhllnooooorrrsu" => ["chlorofluorocarbons"],
      "acefiiiilmnooprsstv" => ["oversimplifications"],
      "aceiiiiinnossstttvv" => ["antivivisectionists"],
      "aciiilnnnoosttttuuy" => ["unconstitutionality"],
      "bceehiiiilmnnoprsty" => ["incomprehensibility"],
      "cceeeegiillnnnorttu" => ["counterintelligence"],
      "cceeegiinnnorrsstuu" => ["counterinsurgencies"]}
    |> Map.get(string_id)
  end
end
