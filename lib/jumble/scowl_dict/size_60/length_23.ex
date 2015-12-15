defmodule Jumble.ScowlDict.Size60.Length23 do
  def get(string_id) do
    %{"aaccceeeeghhillnoopprrt" => ["electroencephalographic"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaccceeeeghhillnoopprrt"]
    |> Enum.into(HashSet.new)
  end
end
