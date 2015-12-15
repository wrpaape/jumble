defmodule Jumble.ScowlDict.Size40.Length18 do
  def get(string_id) do
    %{"aaacccehiillrrstty" => ["characteristically"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"]}
    |> Map.get(string_id)
  end
end
