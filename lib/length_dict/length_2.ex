defmodule LengthDict.Length2 do
  @length_2_length_dict %{'ex' => ["ex"], 'ru' => ["ur"], 'nu' => ["nu", "un"], 'Od' => ["Od"], 'no' => ["no", "on"], 'Ho' => ["Ho"], 'Mo' => ["Mo"], 'lo' => ["lo"], 'at' => ["at", "ta"], 'st' => ["st"], 'go' => ["go"], 'by' => ["by"], 'oz' => ["zo"], 'Lo' => ["Lo"], 'my' => ["my", "ym"], 'Ah' => ["Ah"], 'su' => ["us"], 'Og' => ["Og"], 'iw' => ["wi"], 'Os' => ["Os"], 'Ti' => ["Ti"], 'an' => ["an", "na"], 'fi' => ["fi", "if"], 'As' => ["As"], 'ap' => ["pa"], 'Ma' => ["Ma"], 'ae' => ["ae", "ea"], 'al' => ["al", "la"], 'en' => ["en", "ne"], 'di' => ["di", "id"], 'eo' => ["oe"], 'Ji' => ["Ji"], 'ey' => ["ey", "ye"], 'Ga' => ["Ga"], 'Vu' => ["Vu"], 'aw' => ["aw", "wa"], 'Mr' => ["Mr"], 'do' => ["do", "od"], 'ho' => ["ho", "oh"], 'es' => ["es", "se"], 'Td' => ["Td"], 'jo' => ["jo"], 'ix' => ["xi"], 'in' => ["in", "ni"], 'ah' => ["ah", "ha"], 'Al' => ["Al"], 'el' => ["el"], 'Em' => ["Em"], 'tu' => ["tu", ...], 'ar' => [...], ...}
  
  def get(string_id) do
    @length_2_length_dict
    |> Map.get(string_id)
  end
end
