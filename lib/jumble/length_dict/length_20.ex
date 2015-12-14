defmodule Jumble.LengthDict.Length20 do
  def get(string_id) do
    %{"aaaadeiiiimmnnnnoprr" => ["andrianampoinimerina"],
      "aaacccehiillnrrsttuy" => ["uncharacteristically"],
      "aacceeeeghllmnooprrt" => ["electroencephalogram"],
      "aceeilnnooorrrttuuvy" => ["counterrevolutionary"]}
    |> Map.get(string_id)
  end
end
