defmodule Jumble.ScowlDict.Size70.Length28 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrssssttt" => ["antidisestablishmentarianism"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiiilmmnnnrssssttt"]
    |> Enum.into(HashSet.new)
  end
end
