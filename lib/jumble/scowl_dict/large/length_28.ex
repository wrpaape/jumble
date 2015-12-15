defmodule Jumble.ScowlDict.Large.Length28 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrssssttt" => ["antidisestablishmentarianism"],
      "aaaacdeeeeeeehiilmnnrsttttty" => ["ethylenediaminetetraacetates"],
      "ccdddeeehhinooooorrrrsttxyyy" => ["hydroxydehydrocorticosterone"]}
    |> Map.get(string_id)
  end
end
