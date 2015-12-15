defmodule Jumble.ScowlDict.Size55.Length2 do
  def get(string_id) do
    %{"lo" => ["lo"], "oy" => ["yo"], "fo" => ["of"], "hu" => ["uh"],
      "ah" => ["ah", "ha"], "er" => ["er", "re"], "gs" => ["gs"], "ls" => ["ls"],
      "su" => ["us"], "ap" => ["pa"], "ks" => ["ks"], "ad" => ["ad"],
      "my" => ["my"], "al" => ["la"], "cs" => ["cs"], "ms" => ["ms"],
      "nu" => ["nu"], "es" => ["es"], "ip" => ["pi"], "af" => ["fa"],
      "am" => ["ma", "am"], "ew" => ["we"], "eh" => ["eh", "he"], "pu" => ["up"],
      "ox" => ["ox"], "hs" => ["sh"], "rs" => ["rs"], "io" => ["oi"],
      "no" => ["no", "on"], "ow" => ["ow"], "hi" => ["hi"], "as" => ["as"],
      "im" => ["mi"], "ey" => ["ye"], "ho" => ["ho", "oh"], "mu" => ["um", "mu"],
      "do" => ["do"], "at" => ["ta", "at"], "ot" => ["to"], "os" => ["so"],
      "go" => ["go"], "em" => ["em", "me"], "an" => ["an"], "in" => ["in"],
      "fi" => ["if"], "it" => ["ti", "it"], "ex" => ["ex"], "be" => ["be"],
      "st" => ["ts"], "is" => ["is"], "by" => ["by"], "or" => ["or"],
      "di" => ["id"]}
    |> Map.get(string_id)
  end
end
