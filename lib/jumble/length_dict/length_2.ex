defmodule Jumble.LengthDict.Length2 do
  @length_2_length_dict  %{'ex' => ["ex"], 'ru' => ["ur"], 'nu' => ["nu", "un"], 'Od' => ["Od"],
                           'no' => ["no", "on"], 'Ho' => ["Ho"], 'Mo' => ["Mo"], 'lo' => ["lo"],
                           'at' => ["at", "ta"], 'st' => ["st"], 'go' => ["go"], 'by' => ["by"],
                           'oz' => ["zo"], 'Lo' => ["Lo"], 'my' => ["my", "ym"], 'Ah' => ["Ah"],
                           'su' => ["us"], 'Og' => ["Og"], 'iw' => ["wi"], 'Os' => ["Os"],
                           'Ti' => ["Ti"], 'an' => ["an", "na"], 'fi' => ["fi", "if"], 'As' => ["As"],
                           'ap' => ["pa"], 'Ma' => ["Ma"], 'ae' => ["ae", "ea"], 'al' => ["al", "la"],
                           'en' => ["en", "ne"], 'di' => ["di", "id"], 'eo' => ["oe"], 'Ji' => ["Ji"],
                           'ey' => ["ey", "ye"], 'Ga' => ["Ga"], 'Vu' => ["Vu"], 'aw' => ["aw", "wa"],
                           'Mr' => ["Mr"], 'do' => ["do", "od"], 'ho' => ["ho", "oh"],
                           'es' => ["es", "se"], 'Td' => ["Td"], 'jo' => ["jo"], 'ix' => ["xi"],
                           'in' => ["in", "ni"], 'ah' => ["ah", "ha"], 'Al' => ["Al"], 'el' => ["el"],
                           'Em' => ["Em"], 'tu' => ["tu", "ut"], 'ar' => ["ar", "ra"], 'Hy' => ["Hy"],
                           'il' => ["li"], 'ry' => ["yr"], 'ot' => ["to"], 'as' => ["as", "sa"],
                           'ox' => ["ox"], 'Ed' => ["Ed"], 'or' => ["or"], 'ew' => ["we"],
                           'bu' => ["bu"], 'Ay' => ["Ay"], 'de' => ["de"], 'Hu' => ["Hu"],
                           'ad' => ["ad", "da"], 'ip' => ["pi"], 'fo' => ["of"], 'aa' => ["aa"],
                           'ak' => ["ak", "ka"], 'ko' => ["ko"], 'Lu' => ["Lu"], 'io' => ["io"],
                           'bo' => ["bo"], 'em' => ["em", "me"], 'it' => ["it", "ti"], 'Ab' => ["Ab"],
                           'am' => ["am", "ma"], 'ei' => ["ie"], 'os' => ["os", "so"], 'im' => ["mi"],
                           'Ge' => ["Ge"], 'Ao' => ["Ao"], 'hs' => ["sh"], 'ce' => ["ce"],
                           'eu' => ["eu"], 'op' => ["po"], 'Wa' => ["Wa"], 'hi' => ["hi"],
                           'ag' => ["ga"], 'ax' => ["ax"], 'pu' => ["pu", "up"], 'Wu' => ["Wu"],
                           'be' => ["be"], 'ab' => ["ba"], 'Ju' => ["Ju"], 'mo' => ["mo", "om"],
                           'et' => ["te"], 'Ko' => ["Ko"], 'ay' => ["ay", "ya"], 'gu' => ["ug"],
                           'ac' => ["ca"], 'az' => ["za"], 'eh' => ["eh", "he"], 'Ud' => ["Ud"],
                           'Jo' => ["Jo"], 'Gi' => ["Gi"], 'mu' => ["mu", "um"], 'oy' => ["yo"],
                           'Po' => ["Po"], 'ht' => ["th"], 'er' => ["er", "re"], 'No' => ["No"],
                           'fu' => ["fu"], 'Fo' => ["Fo"], 'Ok' => ["Ok"], 'ai' => ["ai"],
                           'Io' => ["Io"], 'wy' => ["wy"], 'Ro' => ["Ro"], 'ow' => ["ow", "wo"],
                           'is' => ["is", "si"], 'af' => ["fa"], 'Bu' => ["Bu"], 'eg' => ["ge"],
                           'ly' => ["ly"], 'ef' => ["fe"], 'ny' => ["yn"]}
  
  def get(string_id) do
    @length_2_length_dict 
    |> Map.get(string_id)
  end
end
