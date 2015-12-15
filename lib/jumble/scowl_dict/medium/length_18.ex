defmodule Jumble.ScowlDict.Medium.Length18 do
  def get(string_id) do
    %{"aaabiinnnorssttttu" => ["transubstantiation"],
      "aaacchilllnopstyyy" => ["psychoanalytically"],
      "aabceeghiiilnnrtty" => ["interchangeability"],
      "aaccdeeghilooprrrt" => ["electrocardiograph"],
      "aaccdeegilmoorrrst" => ["electrocardiograms"],
      "aacdeeilnnnrsssttt" => ["transcendentalists"],
      "aaceeilnorrssttuvv" => ["ultraconservatives"],
      "aaceiilnnoorsssttv" => ["conversationalists"],
      "abccfhllnooooorrru" => ["chlorofluorocarbon"],
      "accdiiinnnoorssttt" => ["contradistinctions"],
      "acceiiimmnnnoorttu" => ["intercommunication"],
      "acdeeefhiimnnnrsst" => ["disenfranchisement"],
      "aciillnnnoostttuuy" => ["unconstitutionally"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeehiiilnnoprrsstt" => ["interrelationships"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"],
      "ccdeiinnoorssstttu" => ["deconstructionists"],
      "ceeilnnooorrsttuuv" => ["counterrevolutions"],
      "eeehiiiinprsssttvy" => ["hypersensitivities"]}
    |> Map.get(string_id)
  end
end
