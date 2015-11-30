defmodule LengthDict.Length3 do
  @length_3_length_dict %{'dfu' => ["fud"], 'gis' => ["sig"], 'Leo' => ["Leo"], 'esx' => ["sex"], 'Msu' => ["Mus"], 'ads' => ["das", "sad"], 'bbu' => ["bub"], 'eev' => ["eve", "vee"], 'Sal' => ["Sal"], 'Aku' => ["Auk"], 'bdo' => ["bod", "dob"], 'imp' => ["imp"], 'Yin' => ["Yin"], 'joy' => ["joy"], 'afr' => ["far", "fra"], 'cei' => ["ice"], 'boo' => ["boo"], 'add' => ["add", "dad"], 'Ssu' => ["Sus"], 'bgu' => ["bug"], 'Lae' => ["Lea"], 'lmu' => ["lum"], 'akt' => ["kat"], 'Abu' => ["Abu"], 'alx' => ["lax"], 'dil' => ["lid"], 'ekn' => ["ken"], 'ade' => ["ade", "dae"], 'eov' => ["voe"], 'Sno' => ["Son"], 'aav' => ["ava"], 'ekl' => ["elk", "lek"], 'gos' => ["gos", "sog"], 'Rbo' => ["Rob"], 'dev' => ["dev"], 'dpu' => ["dup", "pud"], 'egm' => ["gem"], 'efk' => ["kef"], 'Mac' => ["Mac"], 'Spy' => ["Spy"], 'Hiu' => ["Hui"], 'Ann' => ["Ann"], 'div' => ["div"], 'acl' => ["cal", "lac"], 'ior' => ["rio", "roi"], 'fit' => ["fit"], 'rux' => ["rux"], 'adi' => ["aid"], 'eel' => ["eel", ...], 'Sak' => [...], ...}
  
  def get(string_id) do
    @length_3_length_dict
    |> Map.get(string_id)
  end
end
