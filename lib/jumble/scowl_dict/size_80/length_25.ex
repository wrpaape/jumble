defmodule Jumble.ScowlDict.Size80.Length25 do
  def get(string_id) do
    %{"aaaabdeehiiiilmnnnrsssttt" => ["antidisestablishmentarian"],
      "aaaabeehiiiilmmnnnrsssttt" => ["antiestablishmentarianism"],
      "aaabdeehiiiilmmnnrssssstt" => ["disestablishmentarianisms"],
      "aaadeehhhiillmnnooppsstty" => ["phosphatidylethanolamines"],
      "acceeehiilllmmnoooprrttuy" => ["immunoelectrophoretically"]}
    |> Map.get(string_id)
  end
end
