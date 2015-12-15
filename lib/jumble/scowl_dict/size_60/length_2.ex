defmodule Jumble.ScowlDict.Size60.Length2 do
  def get(string_id) do
    %{"lo" => ["lo"], "oy" => ["yo"], "fo" => ["of"], "hu" => ["uh"],
      "ah" => ["ah", "ha"], "er" => ["er", "re"], "bi" => ["bi"], "gs" => ["gs"],
      "ls" => ["ls"], "su" => ["us"], "ay" => ["ya"], "ap" => ["pa"],
      "ks" => ["ks"], "ad" => ["ad"], "my" => ["my"], "al" => ["la"],
      "cs" => ["cs"], "ms" => ["ms"], "nu" => ["nu"], "es" => ["es"],
      "ip" => ["pi"], "en" => ["en"], "af" => ["fa"], "am" => ["ma", "am"],
      "ew" => ["we"], "eh" => ["eh", "he"], "pu" => ["up"], "ox" => ["ox"],
      "hs" => ["sh"], "rs" => ["rs"], "io" => ["oi"], "no" => ["no", "on"],
      "ow" => ["ow"], "hi" => ["hi"], "as" => ["as"], "mo" => ["om"],
      "im" => ["mi"], "ey" => ["ye"], "ho" => ["ho", "oh"], "ix" => ["xi"],
      "mu" => ["um", "mu"], "do" => ["do"], "at" => ["ta", "at"], "ot" => ["to"],
      "os" => ["so"], "go" => ["go"], "em" => ["em", "me"], "an" => ["an"],
      "in" => ["in"], "fi" => ["if"], "it" => ["ti", "it"], "ex" => ["ex"],
      "be" => ["be"], "st" => ["ts"], "is" => ["is"], "by" => ["by"],
      "or" => ["or"], "di" => ["id"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["lo", "oy", "fo", "hu", "ah", "er", "bi", "gs", "ls", "su", "ay", "ap", "ks",
     "ad", "my", "al", "cs", "ms", "nu", "es", "ip", "en", "af", "am", "ew", "eh",
     "pu", "ox", "hs", "rs", "io", "no", "ow", "hi", "as", "mo", "im", "ey", "ho",
     "ix", "mu", "do", "at", "ot", "os", "go", "em", "an", "in", "fi", "it", "ex",
     "be", "st", "is", "by", "or", "di"]
    |> Enum.into(HashSet.new)
  end
end
