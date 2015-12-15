defmodule Jumble.ScowlDict.Size60.Length20 do
  def get(string_id) do
    %{"aaacccehiillnrrsttuy" => ["uncharacteristically"],
      "aacceeeeghllmnooprrt" => ["electroencephalogram"],
      "aceeilnnooorrrttuuvy" => ["counterrevolutionary"]}
    |> Map.get(string_id)
  end
end
