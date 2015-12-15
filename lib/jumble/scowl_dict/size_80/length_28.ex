defmodule Jumble.ScowlDict.Size80.Length28 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrssssttt" => ["antidisestablishmentarianism"],
      "aaaacdeeeeeeehiilmnnrsttttty" => ["ethylenediaminetetraacetates"]}
    |> Map.get(string_id)
  end
end
