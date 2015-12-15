defmodule Jumble.ScowlDict.Size70.Length2 do
  def get(string_id) do
    %{"lo" => ["lo"], "oy" => ["yo"], "fo" => ["of"], "hu" => ["uh"],
      "bk" => ["kb"], "ah" => ["ah", "ha"], "er" => ["er", "re"], "bi" => ["bi"],
      "gs" => ["gs"], "ls" => ["ls"], "su" => ["us"], "ss" => ["ss"],
      "ay" => ["ya"], "ps" => ["ps"], "ap" => ["pa"], "tu" => ["ut"],
      "oo" => ["oo"], "ks" => ["ks"], "ad" => ["ad"], "my" => ["my"],
      "al" => ["la"], "cs" => ["cs"], "ms" => ["ms"], "nu" => ["nu"],
      "es" => ["es"], "jo" => ["jo"], "ik" => ["ki"], "ip" => ["pi"],
      "en" => ["ne", "en"], "ux" => ["xu"], "af" => ["fa"], "am" => ["ma", "am"],
      "lx" => ["lx"], "bm" => ["mb"], "ew" => ["we"], "fm" => ["mf"],
      "eh" => ["eh", "he"], "pu" => ["up"], "aj" => ["ja"], "ox" => ["ox"],
      "hs" => ["sh"], "rs" => ["rs"], "io" => ["oi"], "no" => ["no", "on"],
      "ow" => ["wo", "ow"], "ln" => ["ln"], "hi" => ["hi"], "as" => ["as"],
      "ai" => ["ai"], "mo" => ["om"], "im" => ["mi"], "lm" => ["lm"],
      "ey" => ["ye"], "ho" => ["ho", "oh"], "ix" => ["xi"], "mu" => ["um", "mu"],
      "do" => ["od", "do"], "at" => ["ta", "at"], "ot" => ["to"], "os" => ["so"],
      "go" => ["go"], "em" => ["em", "me"], "an" => ["an"], "in" => ["in"],
      "de" => ["de"], "fi" => ["if"], "it" => ["ti", "it"], "ex" => ["ex"],
      "be" => ["be"], "st" => ["ts"], "iq" => ["qi"], "ak" => ["ka"],
      "is" => ["si", "is"], "by" => ["by"], "or" => ["or"], "di" => ["id"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["lo", "oy", "fo", "hu", "bk", "ah", "er", "bi", "gs", "ls", "su", "ss", "ay",
     "ps", "ap", "tu", "oo", "ks", "ad", "my", "al", "cs", "ms", "nu", "es", "jo",
     "ik", "ip", "en", "ux", "af", "am", "lx", "bm", "ew", "fm", "eh", "pu", "aj",
     "ox", "hs", "rs", "io", "no", "ow", "ln", "hi", "as", "ai", "mo", "im", "lm",
     "ey", "ho", "ix", "mu", "do", "at", "ot", "os", "go", "em", "an", "in", "de",
     "fi", "it", "ex", "be", "st", "iq", "ak", "is", "by", "or", "di"]
    |> Enum.into(HashSet.new)
  end
end
