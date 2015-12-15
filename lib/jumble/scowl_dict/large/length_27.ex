defmodule Jumble.ScowlDict.Large.Length27 do
  def get(string_id) do
    %{"aaaacdeeeeeeehiilmnnrttttty" => ["ethylenediaminetetraacetate"],
      "aaaccceeeeghhillllnoopprrty" => ["electroencephalographically"],
      "aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"],
      "accceehiillmmoooopprrrsttty" => ["microspectrophotometrically"],
      "ccddeeehinooooorrrssttxxyyy" => ["hydroxydesoxycorticosterone"]}
    |> Map.get(string_id)
  end
end
