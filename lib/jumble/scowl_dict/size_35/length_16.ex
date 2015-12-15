defmodule Jumble.ScowlDict.Size35.Length16 do
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

  def valid_ids do
    ["aaabcghiilooprtu", "aabccegilnnnortu", "aaccegiknnortttu", "aacehiillnssttuy",
     "aaceilnnnnorsttt", "aaeeeilrrrrstttx", "aagiiimnoppprrst", "aaiiimnooppprrst",
     "acceiimmnnoostux", "acdeiiiilmnnrsty", "aceeiilnnnnorttt", "acefiiinnooprsst",
     "aciillnnoostttuy", "aciilnnnoostttuu", "addegiimnnnrsstu", "adeiinooopprrstt",
     "aeeeeinnprrsttuv", "aghhillmooopsstt", "bceeehiilmnnoprs", "beeiiiilnoprssst",
     "beiiiilnoprrssty", "ccceeiklnoorstuw"]
    |> Enum.into(HashSet.new)
  end
end
