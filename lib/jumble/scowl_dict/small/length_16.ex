defmodule Jumble.ScowlDict.Small.Length16 do
  def get(string_id) do
    %{"aaabcghiilooprtu" => ["autobiographical"],
      "aabccegilnnnortu" => ["counterbalancing"],
      "aaccegiknnortttu" => ["counterattacking"],
      "aacehiillnssttuy" => ["enthusiastically"],
      "aaceilnnnnorsttt" => ["transcontinental"],
      "aaeeeilrrrrstttx" => ["extraterrestrial"],
      "aagiiimnoppprrst" => ["misappropriating"],
      "aaiiimnooppprrst" => ["misappropriation"],
      "acceiimmnnoostux" => ["excommunications"],
      "acdeiiiilmnnrsty" => ["indiscriminately"],
      "aceeiilnnnnorttt" => ["intercontinental"],
      "acefiiinnooprsst" => ["personifications"],
      "aciillnnoostttuy" => ["constitutionally"],
      "aciilnnnoostttuu" => ["unconstitutional"],
      "addegiimnnnrsstu" => ["misunderstanding"],
      "adeiinooopprrstt" => ["disproportionate"],
      "aeeeeinnprrsttuv" => ["unrepresentative"],
      "aghhillmooopsstt" => ["ophthalmologists"],
      "bceeehiilmnnoprs" => ["incomprehensible"],
      "beeiiiilnoprssst" => ["responsibilities"],
      "beiiiilnoprrssty" => ["irresponsibility"],
      "ccceeiklnoorstuw" => ["counterclockwise"]}
    |> Map.get(string_id)
  end
end
