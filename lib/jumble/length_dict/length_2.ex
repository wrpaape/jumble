defmodule Jumble.LengthDict.Length2 do
  @length_2_length_dict  %{"eg" => ["ge"], "lo" => ["lo"], "eo" => ["oe"], "Ab" => ["Ab"],
                           "oy" => ["yo"], "ae" => ["ae", "ea"], "el" => ["el"], "fo" => ["of"],
                           "Ho" => ["Ho"], "il" => ["li"], "ac" => ["ca"], "ah" => ["ah", "ha"],
                           "er" => ["er", "re"], "Ah" => ["Ah"], "Lo" => ["Lo"], "su" => ["us"],
                           "Od" => ["Od"], "ay" => ["ay", "ya"], "et" => ["te"], "Wa" => ["Wa"],
                           "ap" => ["pa"], "tu" => ["tu", "ut"], "Ay" => ["Ay"], "Mr" => ["Mr"],
                           "gu" => ["ug"], "aw" => ["aw", "wa"], "ad" => ["ad", "da"],
                           "my" => ["my", "ym"], "ly" => ["ly"], "al" => ["al", "la"], "Em" => ["Em"],
                           "Vu" => ["Vu"], "nu" => ["nu", "un"], "oz" => ["zo"], "Al" => ["Al"],
                           "es" => ["es", "se"], "jo" => ["jo"], "No" => ["No"], "ab" => ["ba"],
                           "Hu" => ["Hu"], "ip" => ["pi"], "ag" => ["ga"], "Os" => ["Os"],
                           "en" => ["en", "ne"], "af" => ["fa"], "Og" => ["Og"], "Po" => ["Po"],
                           "am" => ["am", "ma"], "ew" => ["we"], "ce" => ["ce"], "Fo" => ["Fo"],
                           "eh" => ["eh", "he"], "pu" => ["pu", "up"], "wy" => ["wy"], "Gi" => ["Gi"],
                           "ox" => ["ox"], "hs" => ["sh"], "Ed" => ["Ed"], "ht" => ["th"],
                           "io" => ["io"], "no" => ["no", "on"], "ow" => ["ow", "wo"], "ei" => ["ie"],
                           "Ju" => ["Ju"], "hi" => ["hi"], "as" => ["as", "sa"], "Ko" => ["Ko"],
                           "ai" => ["ai"], "Ro" => ["Ro"], "Ti" => ["Ti"], "bu" => ["bu"],
                           "mo" => ["mo", "om"], "im" => ["mi"], "Bu" => ["Bu"], "ny" => ["yn"],
                           "ey" => ["ey", "ye"], "ko" => ["ko"], "ho" => ["ho", "oh"], "Mo" => ["Mo"],
                           "ix" => ["xi"], "Jo" => ["Jo"], "mu" => ["mu", "um"], "Ge" => ["Ge"],
                           "do" => ["do", "od"], "bo" => ["bo"], "Ao" => ["Ao"], "ru" => ["ur"],
                           "Ji" => ["Ji"], "Lu" => ["Lu"], "at" => ["at", "ta"], "ot" => ["to"],
                           "Td" => ["Td"], "eu" => ["eu"], "op" => ["po"], "fu" => ["fu"],
                           "os" => ["os", "so"], "go" => ["go"], "em" => ["em", "me"],
                           "an" => ["an", "na"], "in" => ["in", "ni"], "de" => ["de"],
                           "fi" => ["fi", "if"], "Ok" => ["Ok"], "ry" => ["yr"], "it" => ["it", "ti"],
                           "Io" => ["Io"], "ex" => ["ex"], "be" => ["be"], "Wu" => ["Wu"],
                           "aa" => ["aa"], "ax" => ["ax"], "iw" => ["wi"], "Ud" => ["Ud"],
                           "az" => ["za"], "st" => ["st"], "ak" => ["ak", "ka"], "is" => ["is", "si"],
                           "ef" => ["fe"], "As" => ["As"], "Ga" => ["Ga"], "by" => ["by"],
                           "or" => ["or"], "Ma" => ["Ma"], "Hy" => ["Hy"], "di" => ["di", "id"],
                           "ar" => ["ar", "ra"]}
  
  def get(string_id) do
    @length_2_length_dict 
    |> Map.get(string_id)
  end
end
