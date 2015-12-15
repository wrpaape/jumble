defmodule Jumble.ScowlDict.Size80.Length2 do
  def get(string_id) do
    %{"lo" => ["lo"], "oy" => ["oy", "yo"], "sy" => ["ys"], "fo" => ["of"],
      "hu" => ["uh"], "bk" => ["kb"], "ah" => ["ah", "ha"], "er" => ["er", "re"],
      "bi" => ["bi"], "gs" => ["gs"], "ls" => ["ls"], "su" => ["us"],
      "ss" => ["ss"], "ay" => ["ya"], "ps" => ["ps"], "ap" => ["pa"],
      "tu" => ["ut"], "oo" => ["oo"], "gu" => ["ug"], "ks" => ["ks"],
      "ad" => ["da", "ad"], "my" => ["my"], "al" => ["la"], "cs" => ["cs"],
      "ms" => ["ms"], "nu" => ["un", "nu"], "oz" => ["zo"], "es" => ["es"],
      "jo" => ["jo"], "ik" => ["ki"], "ab" => ["ba"], "ip" => ["pi"],
      "ag" => ["ag"], "en" => ["ne", "en"], "ux" => ["xu"], "ou" => ["ou"],
      "af" => ["fa"], "am" => ["ma", "am"], "lx" => ["lx"], "js" => ["js"],
      "uy" => ["yu"], "bm" => ["mb"], "ew" => ["we"], "fm" => ["mf"],
      "eh" => ["eh", "he"], "pu" => ["up"], "ds" => ["ds"], "aj" => ["ja"],
      "ox" => ["ox"], "hs" => ["hs", "sh"], "rs" => ["rs"], "io" => ["io", "oi"],
      "no" => ["no", "on"], "ow" => ["wo", "ow"], "ln" => ["ln"], "ns" => ["ns"],
      "qs" => ["qs"], "hi" => ["hi"], "as" => ["as"], "ai" => ["ai"],
      "ky" => ["ky"], "mo" => ["om"], "im" => ["mi"], "lm" => ["lm"],
      "ny" => ["ny"], "ey" => ["ye"], "ko" => ["ko"], "ho" => ["ho", "oh"],
      "ix" => ["xi"], "mu" => ["um", "mu"], "do" => ["od", "do"], "ru" => ["ur"],
      "sz" => ["zs"], "at" => ["ta", "at"], "ot" => ["to"], "sx" => ["xs"],
      "fy" => ["fy"], "op" => ["po"], "os" => ["so"], "go" => ["go"],
      "em" => ["em", "me"], "an" => ["na", "an"], "in" => ["in"], "de" => ["de"],
      "fi" => ["if"], "it" => ["ti", "it"], "ex" => ["ex"], "be" => ["be"],
      "az" => ["za"], "fs" => ["fs"], "st" => ["ts"], "sw" => ["ws"],
      "iq" => ["qi"], "ak" => ["ka"], "is" => ["si", "is"], "ef" => ["ef"],
      "by" => ["by"], "or" => ["or"], "di" => ["id"], "bs" => ["bs"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["lo", "oy", "sy", "fo", "hu", "bk", "ah", "er", "bi", "gs", "ls", "su", "ss",
     "ay", "ps", "ap", "tu", "oo", "gu", "ks", "ad", "my", "al", "cs", "ms", "nu",
     "oz", "es", "jo", "ik", "ab", "ip", "ag", "en", "ux", "ou", "af", "am", "lx",
     "js", "uy", "bm", "ew", "fm", "eh", "pu", "ds", "aj", "ox", "hs", "rs", "io",
     "no", "ow", "ln", "ns", "qs", "hi", "as", "ai", "ky", "mo", "im", "lm", "ny",
     "ey", "ko", "ho", "ix", "mu", "do", "ru", "sz", "at", "ot", "sx", "fy", "op",
     "os", "go", "em", "an", "in", "de", "fi", "it", "ex", "be", "az", "fs", "st",
     "sw", "iq", "ak", "is", "ef", "by", "or", "di", "bs"]
    |> Enum.into(HashSet.new)
  end
end
