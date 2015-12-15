defmodule Jumble.ScowlDict.Size40.Length16 do
  def get(string_id) do
    %{"aeeghiilnnprttvy" => ["hyperventilating"],
      "aceeiilnnnnorttt" => ["intercontinental"],
      "aaeeeilrrrrstttx" => ["extraterrestrial"],
      "aacccehiinrrsttu" => ["uncharacteristic"],
      "acehhiopprssstty" => ["psychotherapists"],
      "aaceilnnnnorsttt" => ["transcontinental"],
      "adeiinooopprrstt" => ["disproportionate"],
      "aaiiimnooppprrst" => ["misappropriation"],
      "acefiiinnooprsst" => ["personifications"],
      "aaccegiknnortttu" => ["counterattacking"],
      "aciilnnnoostttuu" => ["unconstitutional"],
      "aaceeghimnoprrst" => ["cinematographers"],
      "aacehiillnssttuy" => ["enthusiastically"],
      "aceeimnnoooprstv" => ["overcompensation"],
      "aaabcghiilooprtu" => ["autobiographical"],
      "aaacgiillnnostty" => ["antagonistically"],
      "acceiimmnnoostux" => ["excommunications"],
      "ccceeiklnoorstuw" => ["counterclockwise"],
      "aceiinnoorsssttv" => ["conservationists"],
      "acdeiiiilmnnrsty" => ["indiscriminately"],
      "addegiimnnnrsstu" => ["misunderstanding"],
      "aghhillmooopsstt" => ["ophthalmologists"],
      "aabccegilnnnortu" => ["counterbalancing"],
      "aaaacchhillmsttw" => ["whatchamacallits"],
      "aeeiilmnnnorsttv" => ["environmentalist"],
      "acdiiinnnoossttu" => ["discontinuations"],
      "beiiiilnoprrssty" => ["irresponsibility"],
      "aceegimnnooprstv" => ["overcompensating"],
      "acdefghiiinnnrss" => ["disenfranchising"],
      "aciillnnoostttuy" => ["constitutionally"],
      "aeeeeinnprrsttuv" => ["unrepresentative"],
      "bceeehiilmnnoprs" => ["incomprehensible"],
      "aefiilnnnoooprrt" => ["nonproliferation"],
      "aeiiiilllmmnortu" => ["multimillionaire"],
      "aagiiimnoppprrst" => ["misappropriating"],
      "aacdfiiiilnoqstu" => ["disqualification"],
      "beeiiiilnoprssst" => ["responsibilities"],
      "aciiimnnnooprstu" => ["mispronunciation"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aeeghiilnnprttvy", "aceeiilnnnnorttt", "aaeeeilrrrrstttx", "aacccehiinrrsttu",
     "acehhiopprssstty", "aaceilnnnnorsttt", "adeiinooopprrstt", "aaiiimnooppprrst",
     "acefiiinnooprsst", "aaccegiknnortttu", "aciilnnnoostttuu", "aaceeghimnoprrst",
     "aacehiillnssttuy", "aceeimnnoooprstv", "aaabcghiilooprtu", "aaacgiillnnostty",
     "acceiimmnnoostux", "ccceeiklnoorstuw", "aceiinnoorsssttv", "acdeiiiilmnnrsty",
     "addegiimnnnrsstu", "aghhillmooopsstt", "aabccegilnnnortu", "aaaacchhillmsttw",
     "aeeiilmnnnorsttv", "acdiiinnnoossttu", "beiiiilnoprrssty", "aceegimnnooprstv",
     "acdefghiiinnnrss", "aciillnnoostttuy", "aeeeeinnprrsttuv", "bceeehiilmnnoprs",
     "aefiilnnnoooprrt", "aeiiiilllmmnortu", "aagiiimnoppprrst", "aacdfiiiilnoqstu",
     "beeiiiilnoprssst", "aciiimnnnooprstu"]
    |> Enum.into(HashSet.new)
  end
end
