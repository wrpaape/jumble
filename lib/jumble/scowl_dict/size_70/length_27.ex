defmodule Jumble.ScowlDict.Size70.Length27 do
  def get(string_id) do
    %{"aabbcdfhiiiiiiilnnoorstttuu" => ["honorificabilitudinitatibus"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aabbcdfhiiiiiiilnnoorstttuu"]
    |> Enum.into(HashSet.new)
  end
end
