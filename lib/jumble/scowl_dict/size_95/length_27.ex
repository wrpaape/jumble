defmodule Jumble.ScowlDict.Size95.Length27 do
  def get(string_id) do
    %{"aaaacdeeeeeeehiilmnnrttttty" => ["ethylenediaminetetraacetate"],
      "aaaccceeeeghhillllnoopprrty" => ["electroencephalographically"],
      "aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"],
      "accceehiillmmoooopprrrsttty" => ["microspectrophotometrically"],
      "ccddeeehinooooorrrssttxxyyy" => ["hydroxydesoxycorticosterone"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaacdeeeeeeehiilmnnrttttty", "aaaccceeeeghhillllnoopprrty",
     "aabbcdfhiiiiiiilnnoorstttuu", "accceehiillmmoooopprrrsttty",
     "ccddeeehinooooorrrssttxxyyy"]
    |> Enum.into(HashSet.new)
  end
end
