defmodule Jumble.ScowlDict.Size70.Length25 do
  def get(string_id) do
    %{"aaaabdeehiiiilmnnnrsssttt" => ["antidisestablishmentarian"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiilmnnnrsssttt"]
    |> Enum.into(HashSet.new)
  end
end
