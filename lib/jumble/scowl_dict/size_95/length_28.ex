defmodule Jumble.ScowlDict.Size95.Length28 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrssssttt" => ["antidisestablishmentarianism"],
      "aaaacdeeeeeeehiilmnnrsttttty" => ["ethylenediaminetetraacetates"],
      "ccdddeeehhinooooorrrrsttxyyy" => ["hydroxydehydrocorticosterone"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiiilmmnnnrssssttt", "aaaacdeeeeeeehiilmnnrsttttty",
     "ccdddeeehhinooooorrrrsttxyyy"]
    |> Enum.into(HashSet.new)
  end
end
