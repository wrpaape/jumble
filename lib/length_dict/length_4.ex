defmodule LengthDict.Length4 do
  @length_4_length_dict %{'gnos' => ["snog", "song"], 'ceov' => ["cove"], 'hlmo' => ["holm"], 'klmo' => ["klom"], 'Ogor' => ["Ogor"], 'empr' => ["perm"], 'alps' => ["salp", "slap"], 'emsu' => ["muse"], 'beij' => ["jibe"], 'almu' => ["alum", "maul"], 'gilo' => ["gilo", "goli"], 'cemo' => ["come"], 'cinz' => ["zinc"], 'ilmy' => ["limy"], 'knoo' => ["nook"], 'eekr' => ["eker", "reek"], 'aafr' => ["afar"], 'adhn' => ["dhan", "hand"], 'mstu' => ["must", "smut", "stum"], 'Kaot' => ["Kota"], 'alyz' => ["lazy"], 'fffu' => ["fuff"], 'Paab' => ["Paba"], 'blot' => ["blot", "bolt"], 'dffu' => ["duff"], 'aeor' => ["aero"], 'ehno' => ["hone"], 'eflw' => ["flew"], 'Ainu' => ["Ainu"], 'appy' => ["yapp"], 'deks' => ["desk"], 'iiiw' => ["iiwi"], 'bcek' => ["beck"], 'cekk' => ["keck"], 'ikrs' => ["risk"], 'dewy' => ["dewy", "wyde"], 'kstu' => ["tusk"], 'antz' => ["zant"], 'bdno' => ["bond"], 'afss' => ["fass"], 'biit' => ["biti"], 'Banu' => ["Buna"], 'aruv' => ["urva"], 'eefm' => ["feme"], 'aklo' => ["kalo", "kola", "loka"], 'ceos' => ["soce"], 'Mcik' => ["Mick"], 'Harv' => ["Harv"], 'Fiot' => ["Fiot"], 'ginw' => [...], ...}
  
  def get(string_id) do
    @length_4_length_dict
    |> Map.get(string_id)
  end
end
