defmodule Jumble.ScowlDict.Size10.Length16 do
  def get(string_id) do
    %{"addegiimnnnrsstu" => ["misunderstanding"]}
    |> Map.get(string_id)
  end
end
