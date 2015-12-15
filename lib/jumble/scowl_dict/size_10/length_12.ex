defmodule Jumble.ScowlDict.Size10.Length12 do
  def get(string_id) do
    %{"abciimnnoost" => ["combinations"], "cilnnoostuuy" => ["continuously"],
      "ceelnnoqstuy" => ["consequently"], "abcdeilnorsy" => ["considerably"],
      "accceimnrstu" => ["circumstance"], "cdeiinoprsst" => ["descriptions"],
      "aceilnnnootv" => ["conventional"], "cceeennoqssu" => ["consequences"],
      "aceinnoorstv" => ["conversation"], "abcdeeilnors" => ["considerable"],
      "aabegimnrrss" => ["embarrassing"], "aaeegmnnrrst" => ["arrangements"],
      "aeilmnosstuu" => ["simultaneous"], "aabeelnnorsu" => ["unreasonable"],
      "cdeegimmnnor" => ["recommending"], "cdiinnoorttu" => ["introduction"],
      "ceeegiinnprx" => ["experiencing"], "aaeegginnrtu" => ["guaranteeing"],
      "bdgiiinrsttu" => ["distributing"], "ceffiilnstuy" => ["sufficiently"],
      "aacegiinpprt" => ["appreciating"], "aefilnooprss" => ["professional"],
      "aaccillnoosy" => ["occasionally"], "aceemnnnnotu" => ["announcement"],
      "aaccillnostu" => ["calculations"], "ceiinnnosstt" => ["inconsistent"],
      "cdeffiiilstu" => ["difficulties"], "aaccdeillnty" => ["accidentally"],
      "aeeeilmnprtx" => ["experimental"], "iiinnosstttu" => ["institutions"],
      "aciiilmnopst" => ["implications"], "aacillprrtuy" => ["particularly"],
      "bdiiinorsttu" => ["distribution"], "aadegiinpprs" => ["disappearing"],
      "abceiilmnopt" => ["incompatible"], "eeeginnprrst" => ["representing"],
      "aciinnnoottu" => ["continuation"], "eegiilmmnnpt" => ["implementing"],
      "abdeeeillrty" => ["deliberately"], "acehiiopsstt" => ["sophisticate"],
      "accgiilmnopt" => ["complicating"], "accefgiiinns" => ["significance"],
      "aaciilnoppst" => ["applications"], "ciinnorssttu" => ["instructions"],
      "ceeegiillnnt" => ["intelligence"], "aaacehilmmtt" => ["mathematical"],
      "accefiillpsy" => ["specifically"], "aaiilmnnoptu" => ["manipulation"],
      "aaeeilnrsttv" => ["alternatives"], "eeeimnqrrstu" => ["requirements"],
      "aehiilnoprst" => ["relationship"], "eeiiinrsstuv" => ["universities"],
      "ceeginnnortu" => ["encountering"], "abeghiilnsst" => ["establishing"],
      "ccefllsssuuy" => ["successfully"], "acdeiillnnty" => ["incidentally"],
      "aaaddeginstv" => ["disadvantage"], "aabcceelnptu" => ["unacceptable"],
      "aefginnrrrst" => ["transferring"], "eeiinnnorttv" => ["intervention"],
      "eegiinnprrtt" => ["interpreting"], "bciinnoorttu" => ["contribution"],
      "acdggiinorsu" => ["discouraging"], "eeeehlnrsstv" => ["nevertheless"],
      "eeimmnoprstv" => ["improvements"], "addiiillnuvy" => ["individually"],
      "ceeeilprstvy" => ["respectively"], "aabcdginorst" => ["broadcasting"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["abciimnnoost", "cilnnoostuuy", "ceelnnoqstuy", "abcdeilnorsy", "accceimnrstu",
     "cdeiinoprsst", "aceilnnnootv", "cceeennoqssu", "aceinnoorstv", "abcdeeilnors",
     "aabegimnrrss", "aaeegmnnrrst", "aeilmnosstuu", "aabeelnnorsu", "cdeegimmnnor",
     "cdiinnoorttu", "ceeegiinnprx", "aaeegginnrtu", "bdgiiinrsttu", "ceffiilnstuy",
     "aacegiinpprt", "aefilnooprss", "aaccillnoosy", "aceemnnnnotu", "aaccillnostu",
     "ceiinnnosstt", "cdeffiiilstu", "aaccdeillnty", "aeeeilmnprtx", "iiinnosstttu",
     "aciiilmnopst", "aacillprrtuy", "bdiiinorsttu", "aadegiinpprs", "abceiilmnopt",
     "eeeginnprrst", "aciinnnoottu", "eegiilmmnnpt", "abdeeeillrty", "acehiiopsstt",
     "accgiilmnopt", "accefgiiinns", "aaciilnoppst", "ciinnorssttu", "ceeegiillnnt",
     "aaacehilmmtt", "accefiillpsy", "aaiilmnnoptu", "aaeeilnrsttv", "eeeimnqrrstu",
     "aehiilnoprst", "eeiiinrsstuv", "ceeginnnortu", "abeghiilnsst", "ccefllsssuuy",
     "acdeiillnnty", "aaaddeginstv", "aabcceelnptu", "aefginnrrrst", "eeiinnnorttv",
     "eegiinnprrtt", "bciinnoorttu", "acdggiinorsu", "eeeehlnrsstv", "eeimmnoprstv",
     "addiiillnuvy", "ceeeilprstvy", "aabcdginorst"]
    |> Enum.into(HashSet.new)
  end
end
