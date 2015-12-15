defmodule Jumble.ScowlDict.Size20.Length1 do
  def get(string_id) do
    %{"a" => ["a"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["a"]
    |> Enum.into(HashSet.new)
  end
end
