defmodule Jumble.ScowlDict.Size95.Length30 do
  def get(string_id) do
    %{"aaccccffhiiiiiiiiilllnnnoopstu" => ["floccinaucinihilipilifications"],
      "aadeehiiilmnnoooooppppqrsssttu" => ["hippopotomonstrosesquipedalian"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaccccffhiiiiiiiiilllnnnoopstu", "aadeehiiilmnnoooooppppqrsssttu"]
    |> Enum.into(HashSet.new)
  end
end
