defmodule Jumble.ScowlDict.Small.Length2 do
  def get(string_id) do
    %{"fo" => ["of"], "ah" => ["ah", "ha"], "er" => ["re"], "su" => ["us"],
      "ap" => ["pa"], "ad" => ["ad"], "my" => ["my"], "cs" => ["cs"],
      "ms" => ["ms"], "ip" => ["pi"], "am" => ["ma", "am"], "ew" => ["we"],
      "eh" => ["eh", "he"], "pu" => ["up"], "ox" => ["ox"], "no" => ["no", "on"],
      "hi" => ["hi"], "as" => ["as"], "ho" => ["ho", "oh"], "mu" => ["mu"],
      "do" => ["do"], "at" => ["at"], "ot" => ["to"], "os" => ["so"],
      "go" => ["go"], "em" => ["em", "me"], "an" => ["an"], "in" => ["in"],
      "fi" => ["if"], "it" => ["it"], "be" => ["be"], "is" => ["is"],
      "by" => ["by"], "or" => ["or"], "di" => ["id"]}
    |> Map.get(string_id)
  end
end
