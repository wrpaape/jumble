defmodule Jumble.LengthDict.Length24 do
  def get(string_id) do
    %{"Aabcdhhiiilnnooooopprrst" => ["Aldiborontiphoscophornia"],
      "aaaabiiilnnnorsssstttttu" => ["transubstantiationalists"],
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
      "aeeeefhlllnoooprrstttuyy" => ["polytetrafluoroethylenes"],
      "bbdeegiinnooopprrrrsttuu" => ["preobtrudingpreobtrusion"],
      "bceeeehiiiiilmnnoprrsstt" => ["intercomprehensibilities"],
      "cceeehiimmoooopprrrssttt" => ["microspectrophotometries"],
      "ceghiilmmnnooooprssstuuy" => ["psychoneuroimmunologists"]}
    |> Map.get(string_id)
  end
end
