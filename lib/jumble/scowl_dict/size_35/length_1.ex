defmodule Jumble.ScowlDict.Size35.Length1 do
  def get(string_id) do
    %{"a" => ["a"], "m" => ["m"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["a", "m"]
    |> Enum.into(HashSet.new)
  end
end
