defmodule Jumble.ScowlDict.Size70.Length30 do
  def get(string_id) do
    %{"aadeehiiilmnnoooooppppqrsssttu" => ["hippopotomonstrosesquipedalian"]}
    |> Map.get(string_id)
  end
end
