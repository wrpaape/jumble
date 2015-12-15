defmodule Jumble.ScowlDict.Size95.Length30 do
  def get(string_id) do
    %{"aaccccffhiiiiiiiiilllnnnoopstu" => ["floccinaucinihilipilifications"],
      "aadeehiiilmnnoooooppppqrsssttu" => ["hippopotomonstrosesquipedalian"]}
    |> Map.get(string_id)
  end
end
