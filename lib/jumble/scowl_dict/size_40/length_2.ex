defmodule Jumble.ScowlDict.Size40.Length2 do
  def get(string_id) do
    %{"oy" => ["yo"], "fo" => ["of"], "hu" => ["uh"], "ah" => ["ah", "ha"],
      "er" => ["re"], "gs" => ["gs"], "ls" => ["ls"], "su" => ["us"],
      "ap" => ["pa"], "ks" => ["ks"], "ad" => ["ad"], "my" => ["my"],
      "cs" => ["cs"], "ms" => ["ms"], "es" => ["es"], "ip" => ["pi"],
      "am" => ["ma", "am"], "ew" => ["we"], "eh" => ["eh", "he"], "pu" => ["up"],
      "ox" => ["ox"], "hs" => ["sh"], "rs" => ["rs"], "no" => ["no", "on"],
      "ow" => ["ow"], "hi" => ["hi"], "as" => ["as"], "im" => ["mi"],
      "ho" => ["ho", "oh"], "mu" => ["um", "mu"], "do" => ["do"], "at" => ["at"],
      "ot" => ["to"], "os" => ["so"], "go" => ["go"], "em" => ["em", "me"],
      "an" => ["an"], "in" => ["in"], "fi" => ["if"], "it" => ["it"],
      "ex" => ["ex"], "be" => ["be"], "st" => ["ts"], "is" => ["is"],
      "by" => ["by"], "or" => ["or"], "di" => ["id"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["oy", "fo", "hu", "ah", "er", "gs", "ls", "su", "ap", "ks", "ad", "my", "cs",
     "ms", "es", "ip", "am", "ew", "eh", "pu", "ox", "hs", "rs", "no", "ow", "hi",
     "as", "im", "ho", "mu", "do", "at", "ot", "os", "go", "em", "an", "in", "fi",
     "it", "ex", "be", "st", "is", "by", "or", "di"]
    |> Enum.into(HashSet.new)
  end
end
