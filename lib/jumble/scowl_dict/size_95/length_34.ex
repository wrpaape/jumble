defmodule Jumble.ScowlDict.Size95.Length34 do
  def get(string_id) do
    %{"aaacccdeefgiiiiiiillloopprrssstuux" => ["supercalifragilisticexpialidocious"],
      "aaaddeeeeehiiiillmmmnnnoopprrtttyy" => ["diaminopropyltetramethylenediamine"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaacccdeefgiiiiiiillloopprrssstuux", "aaaddeeeeehiiiillmmmnnnoopprrtttyy"]
    |> Enum.into(HashSet.new)
  end
end
