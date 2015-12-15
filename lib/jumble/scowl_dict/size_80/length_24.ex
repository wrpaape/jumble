defmodule Jumble.ScowlDict.Size80.Length24 do
  def get(string_id) do
    %{"aaabdeehiiiilmmnnrsssstt" => ["disestablishmentarianism"],
      "aaacccdeeghiilllooprrrty" => ["electrocardiographically"],
      "aaadeehhhiillmnnooppstty" => ["phosphatidylethanolamine"],
      "aacceeeeeghhillnoopprrst" => ["electroencephalographies"],
      "aacceeeeeghhllnoopprrrst" => ["electroencephalographers"],
      "aaceeeiiilllnnoorstttuvz" => ["overintellectualizations"],
      "abccdfhhllnoooooorrrrsuy" => ["hydrochlorofluorocarbons"],
      "accceeehiilllmoooprrrtty" => ["microelectrophoretically"],
      "acceghiillmmnnooooprsuuy" => ["psychoneuroimmunological"],
      "acddeefhhiillmnoooorrstu" => ["dichlorodifluoromethanes"],
      "bceeeehiiiiilmnnoprrsstt" => ["intercomprehensibilities"],
      "cceeehiimmoooopprrrssttt" => ["microspectrophotometries"],
      "ceghiilmmnnooooprssstuuy" => ["psychoneuroimmunologists"]}
    |> Map.get(string_id)
  end
end
