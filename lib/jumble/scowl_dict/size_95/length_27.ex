defmodule Jumble.ScowlDict.Size95.Length27 do
  def get(string_id) do
    %{"aaaacdeeeeeeehiilmnnrttttty" => ["ethylenediaminetetraacetate"],
      "aaaccceeeeghhillllnoopprrty" => ["electroencephalographically"],
      "aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"],
      "accceehiillmmoooopprrrsttty" => ["microspectrophotometrically"],
      "ccddeeehinooooorrrssttxxyyy" => ["hydroxydesoxycorticosterone"]}
    |> Map.get(string_id)
  end
end
