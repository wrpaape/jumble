defmodule Jumble.LengthDict.Length29 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrsssssttt" => ["antidisestablishmentarianisms"],
      "aaccccffhiiiiiiiiilllnnnooptu" => ["floccinaucinihilipilification"],
      "aadeeeeeehhhiilmmmmnnoptttxyy" => ["methylenedioxymethamphetamine"],
      "acceeeehiiiillmmnnnorrrttttyy" => ["cyclotrimethylenetrinitramine"],
      "aeeehhiiiillmmnnnnoprrrttttyy" => ["trinitrophenylmethylnitramine"]}
    |> Map.get(string_id)
  end
end
