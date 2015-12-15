defmodule Jumble.ScowlDict.Size40.Length20 do
  def get(string_id) do
    %{"aaacccehiillnrrsttuy" => ["uncharacteristically"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaacccehiillnrrsttuy"]
    |> Enum.into(HashSet.new)
  end
end
