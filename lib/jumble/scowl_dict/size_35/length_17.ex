defmodule Jumble.ScowlDict.Size35.Length17 do
  def get(string_id) do
    %{"aadfghilorrrsttwy" => ["straightforwardly"],
      "aaeeeilrrrrsstttx" => ["extraterrestrials"],
      "aaiiimnooppprrsst" => ["misappropriations"],
      "abceiiiiilmnopstt" => ["incompatibilities"],
      "abdeghiiiilnnsstu" => ["indistinguishable"],
      "addegiimnnnrssstu" => ["misunderstandings"],
      "aeeeiimnnoprrsstt" => ["misrepresentation"],
      "aeeiiimnnoprrsttt" => ["misinterpretation"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aadfghilorrrsttwy", "aaeeeilrrrrsstttx", "aaiiimnooppprrsst",
     "abceiiiiilmnopstt", "abdeghiiiilnnsstu", "addegiimnnnrssstu",
     "aeeeiimnnoprrsstt", "aeeiiimnnoprrsttt"]
    |> Enum.into(HashSet.new)
  end
end
