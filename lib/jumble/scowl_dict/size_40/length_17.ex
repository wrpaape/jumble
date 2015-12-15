defmodule Jumble.ScowlDict.Size40.Length17 do
  def get(string_id) do
    %{"aacdfiiiilnoqsstu" => ["disqualifications"],
      "aadeiilmnnnnnooot" => ["nondenominational"],
      "aadfghilorrrsttwy" => ["straightforwardly"],
      "aaeeeilrrrrsstttx" => ["extraterrestrials"],
      "aaiiimnooppprrsst" => ["misappropriations"],
      "abceiiiiilmnopstt" => ["incompatibilities"],
      "abdeghiiiilnnsstu" => ["indistinguishable"],
      "aciiimnnnooprsstu" => ["mispronunciations"],
      "addegiimnnnrssstu" => ["misunderstandings"],
      "aeeeiimnnoprrsstt" => ["misrepresentation"],
      "aeeiiimnnoprrsttt" => ["misinterpretation"],
      "aeeiilmnnnorssttv" => ["environmentalists"],
      "aeiiiilllmmnorstu" => ["multimillionaires"],
      "ccdeeinooprrttuuv" => ["counterproductive"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacdfiiiilnoqsstu", "aadeiilmnnnnnooot", "aadfghilorrrsttwy",
     "aaeeeilrrrrsstttx", "aaiiimnooppprrsst", "abceiiiiilmnopstt",
     "abdeghiiiilnnsstu", "aciiimnnnooprsstu", "addegiimnnnrssstu",
     "aeeeiimnnoprrsstt", "aeeiiimnnoprrsttt", "aeeiilmnnnorssttv",
     "aeiiiilllmmnorstu", "ccdeeinooprrttuuv"]
    |> Enum.into(HashSet.new)
  end
end
