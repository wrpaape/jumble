defmodule Jumble.ScowlDict.Size80.Length25 do
  def get(string_id) do
    %{"aaaabdeehiiiilmnnnrsssttt" => ["antidisestablishmentarian"],
      "aaaabeehiiiilmmnnnrsssttt" => ["antiestablishmentarianism"],
      "aaabdeehiiiilmmnnrssssstt" => ["disestablishmentarianisms"],
      "aaadeehhhiillmnnooppsstty" => ["phosphatidylethanolamines"],
      "acceeehiilllmmnoooprrttuy" => ["immunoelectrophoretically"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiilmnnnrsssttt", "aaaabeehiiiilmmnnnrsssttt",
     "aaabdeehiiiilmmnnrssssstt", "aaadeehhhiillmnnooppsstty",
     "acceeehiilllmmnoooprrttuy"]
    |> Enum.into(HashSet.new)
  end
end
