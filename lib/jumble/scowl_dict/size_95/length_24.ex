defmodule Jumble.ScowlDict.Size95.Length24 do
  def get(string_id) do
    %{"aaaabiiilnnnorsssstttttu" => ["transubstantiationalists"],
      "aaaaccccceeehhimoorsstyz" => ["schizosaccharomycetaceae"],
      "aaabdeehiiiilmmnnrsssstt" => ["disestablishmentarianism"],
      "aaacccdeeghiilllooprrrty" => ["electrocardiographically"],
      "aaadeehhhiillmnnooppstty" => ["phosphatidylethanolamine"],
      "aacccgghhiillloooooppsty" => ["pathologicopsychological"],
      "aacceeeeeghhillnoopprrst" => ["electroencephalographies"],
      "aacceeeeeghhllnoopprrrst" => ["electroencephalographers"],
      "aacdeeehhiiillmnnnoprrsy" => ["diphenylaminechlorarsine"],
      "aacdeehhiimoooprrrtttyyz" => ["thyroparathyroidectomize"],
      "aacdeeiiiilnnnooprsstttu" => ["pseudointernationalistic"],
      "aaceeeiiilllnnoorstttuvz" => ["overintellectualizations"],
      "aaddeeefhhlllmooprstuxyy" => ["formaldehydesulphoxylate"],
      "aadeeehhhiillnnooopprttt" => ["tetraiodophenolphthalein"],
      "abccdfhhllnoooooorrrrsuy" => ["hydrochlorofluorocarbons"],
      "abcdefhiiiiiiilnnoorsttu" => ["honorificabilitudinities"],
      "accceeehiilllmoooprrrtty" => ["microelectrophoretically"],
      "acccefhhiiiiillnoooppsst" => ["scientificophilosophical"],
      "acceeeeghiilmmnoorrtttty" => ["magnetothermoelectricity"],
      "acceghiillmmnnooooprsuuy" => ["psychoneuroimmunological"],
      "acddeefhhiillmnoooorrstu" => ["dichlorodifluoromethanes"],
      "bbdeegiinnooopprrrrsttuu" => ["preobtrudingpreobtrusion"],
      "bceeeehiiiiilmnnoprrsstt" => ["intercomprehensibilities"],
      "cceeehiimmoooopprrrssttt" => ["microspectrophotometries"],
      "ceghiilmmnnooooprssstuuy" => ["psychoneuroimmunologists"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabiiilnnnorsssstttttu", "aaaaccccceeehhimoorsstyz",
     "aaabdeehiiiilmmnnrsssstt", "aaacccdeeghiilllooprrrty",
     "aaadeehhhiillmnnooppstty", "aacccgghhiillloooooppsty",
     "aacceeeeeghhillnoopprrst", "aacceeeeeghhllnoopprrrst",
     "aacdeeehhiiillmnnnoprrsy", "aacdeehhiimoooprrrtttyyz",
     "aacdeeiiiilnnnooprsstttu", "aaceeeiiilllnnoorstttuvz",
     "aaddeeefhhlllmooprstuxyy", "aadeeehhhiillnnooopprttt",
     "abccdfhhllnoooooorrrrsuy", "abcdefhiiiiiiilnnoorsttu",
     "accceeehiilllmoooprrrtty", "acccefhhiiiiillnoooppsst",
     "acceeeeghiilmmnoorrtttty", "acceghiillmmnnooooprsuuy",
     "acddeefhhiillmnoooorrstu", "bbdeegiinnooopprrrrsttuu",
     "bceeeehiiiiilmnnoprrsstt", "cceeehiimmoooopprrrssttt",
     "ceghiilmmnnooooprssstuuy"]
    |> Enum.into(HashSet.new)
  end
end
