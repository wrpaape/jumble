defmodule Jumble.ScowlDict.Size55.Length20 do
  def get(string_id) do
    %{"aaacccehiillnrrsttuy" => ["uncharacteristically"],
      "aacceeeeghllmnooprrt" => ["electroencephalogram"],
      "aceeilnnooorrrttuuvy" => ["counterrevolutionary"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaacccehiillnrrsttuy", "aacceeeeghllmnooprrt", "aceeilnnooorrrttuuvy"]
    |> Enum.into(HashSet.new)
  end
end
