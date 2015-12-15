defmodule Jumble.ScowlDict.Size10.Length15 do
  def get(string_id) do
    %{"aadfghiorrrsttw" => ["straightforward"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aadfghiorrrsttw"]
    |> Enum.into(HashSet.new)
  end
end
