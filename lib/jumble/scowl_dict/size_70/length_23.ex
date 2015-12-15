defmodule Jumble.ScowlDict.Size70.Length23 do
  def get(string_id) do
    %{"aaccceeeeghhillnoopprrt" => ["electroencephalographic"],
      "acddeefhhiillmnoooorrtu" => ["dichlorodifluoromethane"]}
    |> Map.get(string_id)
  end
end
