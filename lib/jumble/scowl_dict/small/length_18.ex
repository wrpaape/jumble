defmodule Jumble.ScowlDict.Small.Length18 do
  def get(string_id) do
    %{"aaacccehiillrrstty" => ["characteristically"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"]}
    |> Map.get(string_id)
  end
end
