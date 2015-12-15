defmodule Jumble.ScowlDict.Size20.Length16 do
  def get(string_id) do
    %{"addegiimnnnrsstu" => ["misunderstanding"],
      "bceeehiilmnnoprs" => ["incomprehensible"],
      "beeiiiilnoprssst" => ["responsibilities"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["addegiimnnnrsstu", "bceeehiilmnnoprs", "beeiiiilnoprssst"]
    |> Enum.into(HashSet.new)
  end
end
