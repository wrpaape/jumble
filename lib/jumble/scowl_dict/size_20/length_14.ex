defmodule Jumble.ScowlDict.Size20.Length14 do
  def get(string_id) do
    %{"adeeehhllortwy" => ["wholeheartedly"],
      "acfgiinnoorstu" => ["configurations"],
      "acghiiinopsstt" => ["sophisticating"],
      "accefiiinopsst" => ["specifications"],
      "acdeiinnoorsst" => ["considerations"],
      "ccdeeennooprrs" => ["correspondence"],
      "dgghiiiinnsstu" => ["distinguishing"],
      "aaacehiimmnstt" => ["mathematicians"],
      "aabddeelnnrstu" => ["understandable"],
      "bceeehilmnoprs" => ["comprehensible"],
      "aacfinorssttuy" => ["unsatisfactory"],
      "aadeiiimnrsttv" => ["administrative"],
      "aeeeeinprrsttv" => ["representative"],
      "cceeeiinnnnosv" => ["inconveniences"],
      "addeimnnrssstu" => ["misunderstands"],
      "aeeiilmmnnoptt" => ["implementation"],
      "acdeeimmnnoort" => ["recommendation"],
      "acefinrrrsttuu" => ["infrastructure"],
      "aafimnnoorrstt" => ["transformation"],
      "aeillmnosstuuy" => ["simultaneously"],
      "cceimoooprrrss" => ["microprocessor"],
      "aeeeinnoprrstt" => ["representation"],
      "adeiimnnoppstt" => ["disappointment"],
      "aeeiinnoprrttt" => ["interpretation"],
      "aeeeillmnprtxy" => ["experimentally"],
      "ccdeeeiinnnnov" => ["inconvenienced"],
      "adeeeimnrssttv" => ["advertisements"],
      "aadefilmnnsttu" => ["fundamentalist"],
      "aegiiinnossttv" => ["investigations"],
      "aciiillmnopttu" => ["multiplication"],
      "aaccfiiilnosst" => ["classification"],
      "accefiiillnsty" => ["scientifically"],
      "acceeilllnorty" => ["electronically"],
      "acdiiiimnnorst" => ["discrimination"],
      "aaccdeillmorty" => ["democratically"],
      "aacfiilorsstty" => ["satisfactorily"],
      "aacfiiilnoqstu" => ["qualifications"],
      "aceeelmnoprtux" => ["counterexample"],
      "adeimnnoorsstt" => ["demonstrations"],
      "aaacehillmmtty" => ["mathematically"],
      "abeehilmnssstt" => ["establishments"],
      "aadiiimnnorstt" => ["administration"],
      "beiiilnoprssty" => ["responsibility"],
      "acciimmnnoostu" => ["communications"],
      "aciilnnoostttu" => ["constitutional"],
      "aacccehiirrstt" => ["characteristic"],
      "adeeefimnnoort" => ["aforementioned"],
      "acdefiiiinnott" => ["identification"],
      "deeeeimnprrsst" => ["misrepresented"],
      "aaddeegnrrstuu" => ["undergraduates"],
      "deeeiimnprrstt" => ["misinterpreted"],
      "cceimmooprrstu" => ["microcomputers"],
      "acdgiiiimnnrst" => ["discriminating"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["adeeehhllortwy", "acfgiinnoorstu", "acghiiinopsstt", "accefiiinopsst",
     "acdeiinnoorsst", "ccdeeennooprrs", "dgghiiiinnsstu", "aaacehiimmnstt",
     "aabddeelnnrstu", "bceeehilmnoprs", "aacfinorssttuy", "aadeiiimnrsttv",
     "aeeeeinprrsttv", "cceeeiinnnnosv", "addeimnnrssstu", "aeeiilmmnnoptt",
     "acdeeimmnnoort", "acefinrrrsttuu", "aafimnnoorrstt", "aeillmnosstuuy",
     "cceimoooprrrss", "aeeeinnoprrstt", "adeiimnnoppstt", "aeeiinnoprrttt",
     "aeeeillmnprtxy", "ccdeeeiinnnnov", "adeeeimnrssttv", "aadefilmnnsttu",
     "aegiiinnossttv", "aciiillmnopttu", "aaccfiiilnosst", "accefiiillnsty",
     "acceeilllnorty", "acdiiiimnnorst", "aaccdeillmorty", "aacfiilorsstty",
     "aacfiiilnoqstu", "aceeelmnoprtux", "adeimnnoorsstt", "aaacehillmmtty",
     "abeehilmnssstt", "aadiiimnnorstt", "beiiilnoprssty", "acciimmnnoostu",
     "aciilnnoostttu", "aacccehiirrstt", "adeeefimnnoort", "acdefiiiinnott",
     "deeeeimnprrsst", "aaddeegnrrstuu", "deeeiimnprrstt", "cceimmooprrstu",
     "acdgiiiimnnrst"]
    |> Enum.into(HashSet.new)
  end
end
