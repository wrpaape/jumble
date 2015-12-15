defmodule Jumble.ScowlDict.Small.Length17 do
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
end
