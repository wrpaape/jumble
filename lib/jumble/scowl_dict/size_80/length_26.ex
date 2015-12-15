defmodule Jumble.ScowlDict.Size80.Length26 do
  def get(string_id) do
    %{"aaaabeehiiiilmmnnnrssssttt" => ["antiestablishmentarianisms"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabeehiiiilmmnnnrssssttt"]
    |> Enum.into(HashSet.new)
  end
end
