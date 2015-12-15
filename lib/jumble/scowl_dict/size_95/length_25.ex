defmodule Jumble.ScowlDict.Size95.Length25 do
  def get(string_id) do
    %{"aaaabdeehiiiilmnnnrsssttt" => ["antidisestablishmentarian"],
      "aaaabeehiiiilmmnnnrsssttt" => ["antiestablishmentarianism"],
      "aaabdeehiiiilmmnnrssssstt" => ["disestablishmentarianisms"],
      "aaaccceeeeghhilllnoopprrt" => ["electroencephalographical"],
      "aaadeehhhiillmnnooppsstty" => ["phosphatidylethanolamines"],
      "aaeeeeeeeggnnorrrrrrsstty" => ["regeneratoryregeneratress"],
      "acccdeeeehhilllmnorrtttyy" => ["demethylchlortetracycline"],
      "accceehiilmmoooopprrrsttt" => ["microspectrophotometrical"],
      "acccghhhiiilllooooopppssy" => ["philosophicopsychological"],
      "acceeehiilllmmnoooprrttuy" => ["immunoelectrophoretically"],
      "bceeeeehiilmnnnopprrssssu" => ["superincomprehensibleness"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiilmnnnrsssttt", "aaaabeehiiiilmmnnnrsssttt",
     "aaabdeehiiiilmmnnrssssstt", "aaaccceeeeghhilllnoopprrt",
     "aaadeehhhiillmnnooppsstty", "aaeeeeeeeggnnorrrrrrsstty",
     "acccdeeeehhilllmnorrtttyy", "accceehiilmmoooopprrrsttt",
     "acccghhhiiilllooooopppssy", "acceeehiilllmmnoooprrttuy",
     "bceeeeehiilmnnnopprrssssu"]
    |> Enum.into(HashSet.new)
  end
end
