defmodule Jumble.LengthDict.Length34 do
  def get(string_id) do
    %{"aaacccdeefgiiiiiiillloopprrssstuux" => ["supercalifragilisticexpialidocious"],
      "aaaddeeeeehiiiillmmmnnnoopprrtttyy" => ["diaminopropyltetramethylenediamine"]}
    |> Map.get(string_id)
  end
end
