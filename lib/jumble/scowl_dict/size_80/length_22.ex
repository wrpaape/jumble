defmodule Jumble.ScowlDict.Size80.Length22 do
  def get(string_id) do
    %{"acceeiiijknnoorsstttuv" => ["keratoconjunctivitises"],
      "aacceeeeghhllnoopprrty" => ["electroencephalography"],
      "cceehimmoooopprrrsttty" => ["microspectrophotometry"],
      "acceeeemnnoorrrssttuuu" => ["countercountermeasures"],
      "eeeeghiiilnnoopprssstv" => ["philoprogenitivenesses"],
      "abcceeehllllmoorstuxyy" => ["carboxymethylcellulose"],
      "abdeghiiiiiiilnnsssttu" => ["indistinguishabilities"],
      "acceeghiilllloooprstyy" => ["electrophysiologically"],
      "adeeeiinnooopprrsssstt" => ["disproportionatenesses"],
      "aaeiiiiilnnnoorsttttuz" => ["reinstitutionalization"],
      "aaeeeiilmnnnnooprrsstt" => ["nonrepresentationalism"],
      "abcdfhiiiiiilnnoorttuy" => ["honorificabilitudinity"],
      "aaacceghilllmnoooprruy" => ["neuropharmacologically"],
      "aceeeiinnnooprrrsttttu" => ["counterinterpretations"],
      "aeeeeeeinnnprrssssttuv" => ["unrepresentativenesses"],
      "aaeeeeeehhilmmnnrtttxy" => ["hexamethylenetetramine"],
      "aaabdeehiiilmnnrsssstt" => ["disestablishmentarians"],
      "acddeeeghhhlloopprssyy" => ["phosphoglyceraldehydes"],
      "bceeeeiilnnnoorrsssttv" => ["incontrovertiblenesses"],
      "ceehhiiiimmmnoorsssttu" => ["immunohistochemistries"],
      "aaabiiinnnorsssstttttu" => ["transubstantiationists"],
      "acceehillmooopprrsttty" => ["spectrophotometrically"],
      "aacceeiiilmmnooorrstvz" => ["overcommercializations"],
      "aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "agghiillnnooooorrsstty" => ["otorhinolaryngologists"],
      "bceeeeehiilmnnnoprssss" => ["incomprehensiblenesses"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"],
      "aacgghiilllnnooooorrty" => ["otorhinolaryngological"],
      "addeehhiimmoopprrssstu" => ["pseudohermaphroditisms"],
      "aadeiiiiilnnnoosttttuz" => ["deinstitutionalization"],
      "aaaabeehiiilmnnnrssttt" => ["antiestablishmentarian"],
      "aaabcdeghiiillooprrsst" => ["ballistocardiographies"],
      "bceeehiiiilmnnoprrstty" => ["intercomprehensibility"],
      "aaabeehiiilmmnnrsssstt" => ["establishmentarianisms"],
      "aaccdeeehiilmnooprssty" => ["encephalomyocarditises"],
      "cceeehimmoooopprrrsttt" => ["microspectrophotometer"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["acceeiiijknnoorsstttuv", "aacceeeeghhllnoopprrty", "cceehimmoooopprrrsttty",
     "acceeeemnnoorrrssttuuu", "eeeeghiiilnnoopprssstv", "abcceeehllllmoorstuxyy",
     "abdeghiiiiiiilnnsssttu", "acceeghiilllloooprstyy", "adeeeiinnooopprrsssstt",
     "aaeiiiiilnnnoorsttttuz", "aaeeeiilmnnnnooprrsstt", "abcdfhiiiiiilnnoorttuy",
     "aaacceghilllmnoooprruy", "aceeeiinnnooprrrsttttu", "aeeeeeeinnnprrssssttuv",
     "aaeeeeeehhilmmnnrtttxy", "aaabdeehiiilmnnrsssstt", "acddeeeghhhlloopprssyy",
     "bceeeeiilnnnoorrsssttv", "ceehhiiiimmmnoorsssttu", "aaabiiinnnorsssstttttu",
     "acceehillmooopprrsttty", "aacceeiiilmmnooorrstvz", "aacceeeeghhllnoopprrst",
     "agghiillnnooooorrsstty", "bceeeeehiilmnnnoprssss", "aceeeiilnnooorrrsttuuv",
     "aacgghiilllnnooooorrty", "addeehhiimmoopprrssstu", "aadeiiiiilnnnoosttttuz",
     "aaaabeehiiilmnnnrssttt", "aaabcdeghiiillooprrsst", "bceeehiiiilmnnoprrstty",
     "aaabeehiiilmmnnrsssstt", "aaccdeeehiilmnooprssty", "cceeehimmoooopprrrsttt"]
    |> Enum.into(HashSet.new)
  end
end
