defmodule Jumble.ScowlDict.Size80.Length29 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrsssssttt" => ["antidisestablishmentarianisms"],
      "aaccccffhiiiiiiiiilllnnnooptu" => ["floccinaucinihilipilification"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaaabdeehiiiiilmmnnnrsssssttt", "aaccccffhiiiiiiiiilllnnnooptu"]
    |> Enum.into(HashSet.new)
  end
end
