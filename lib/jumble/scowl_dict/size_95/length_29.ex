defmodule Jumble.ScowlDict.Size95.Length29 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrsssssttt" => ["antidisestablishmentarianisms"],
      "aaccccffhiiiiiiiiilllnnnooptu" => ["floccinaucinihilipilification"],
      "aadeeeeeehhhiilmmmmnnoptttxyy" => ["methylenedioxymethamphetamine"],
      "acceeeehiiiillmmnnnorrrttttyy" => ["cyclotrimethylenetrinitramine"],
      "aeeehhiiiillmmnnnnoprrrttttyy" => ["trinitrophenylmethylnitramine"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiiilmmnnnrsssssttt", "aaccccffhiiiiiiiiilllnnnooptu",
     "aadeeeeeehhhiilmmmmnnoptttxyy", "acceeeehiiiillmmnnnorrrttttyy",
     "aeeehhiiiillmmnnnnoprrrttttyy"]
    |> Enum.into(HashSet.new)
  end
end
