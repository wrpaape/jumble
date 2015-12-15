defmodule Jumble.ScowlDict.Size80.Length30 do
  def get(string_id) do
    %{"aadeehiiilmnnoooooppppqrsssttu" => ["hippopotomonstrosesquipedalian"]}
    |> Map.get(string_id)
  end
end
