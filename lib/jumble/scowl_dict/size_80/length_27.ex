defmodule Jumble.ScowlDict.Size80.Length27 do
  def get(string_id) do
    %{"aaaacdeeeeeeehiilmnnrttttty" => ["ethylenediaminetetraacetate"],
      "aaaccceeeeghhillllnoopprrty" => ["electroencephalographically"],
      "aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"]}
    |> Map.get(string_id)
  end
end
