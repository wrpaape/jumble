defmodule Jumble.ScowlDict.Size20.Length17 do
  def get(string_id) do
    %{"abdeghiiiilnnsstu" => ["indistinguishable"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["abdeghiiiilnnsstu"]
    |> Enum.into(HashSet.new)
  end
end
