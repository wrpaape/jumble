defmodule Jumble.ScowlDict.Size10.Length14 do
  def get(string_id) do
    %{"aaddeegnrrstuu" => ["undergraduates"],
      "aadiiimnnorstt" => ["administration"],
      "acciimmnnoostu" => ["communications"],
      "acdeeimmnnoort" => ["recommendation"],
      "acghiiinopsstt" => ["sophisticating"],
      "addeimnnrssstu" => ["misunderstands"],
      "aeeeeinprrsttv" => ["representative"],
      "aeeeinnoprrstt" => ["representation"],
      "aeeiinnoprrttt" => ["interpretation"],
      "aeillmnosstuuy" => ["simultaneously"],
      "beiiilnoprssty" => ["responsibility"]}
    |> Map.get(string_id)
  end
end
