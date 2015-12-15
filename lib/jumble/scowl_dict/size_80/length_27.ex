defmodule Jumble.ScowlDict.Size80.Length27 do
  def get(string_id) do
    %{"aaaacdeeeeeeehiilmnnrttttty" => ["ethylenediaminetetraacetate"],
      "aaaccceeeeghhillllnoopprrty" => ["electroencephalographically"],
      "aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaacdeeeeeeehiilmnnrttttty", "aaaccceeeeghhillllnoopprrty",
     "aabbcdfhiiiiiiilnnoorstttuu"]
    |> Enum.into(HashSet.new)
  end
end
