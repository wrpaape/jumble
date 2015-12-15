defmodule Jumble.ScowlDict.Size55.Length18 do
  def get(string_id) do
    %{"aaabiinnnorssttttu" => ["transubstantiation"],
      "aaacccehiillrrstty" => ["characteristically"],
      "aaacchilllnopstyyy" => ["psychoanalytically"],
      "aabceeghiiilnnrtty" => ["interchangeability"],
      "aaccdeeghilooprrrt" => ["electrocardiograph"],
      "aaccdeegilmoorrrst" => ["electrocardiograms"],
      "aacdeeilnnnrsssttt" => ["transcendentalists"],
      "aaceeilnorrssttuvv" => ["ultraconservatives"],
      "aaceiilnnoorsssttv" => ["conversationalists"],
      "abccfhllnooooorrru" => ["chlorofluorocarbon"],
      "accdiiinnnoorssttt" => ["contradistinctions"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "acceiiimmnnnoorttu" => ["intercommunication"],
      "acdeeefhiimnnnrsst" => ["disenfranchisement"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "aciillnnnoostttuuy" => ["unconstitutionally"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"],
      "aeehiiilnnoprrsstt" => ["interrelationships"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"],
      "ccdeiinnoorssstttu" => ["deconstructionists"],
      "ceeilnnooorrsttuuv" => ["counterrevolutions"],
      "eeehiiiinprsssttvy" => ["hypersensitivities"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaabiinnnorssttttu", "aaacccehiillrrstty", "aaacchilllnopstyyy",
     "aabceeghiiilnnrtty", "aaccdeeghilooprrrt", "aaccdeegilmoorrrst",
     "aacdeeilnnnrsssttt", "aaceeilnorrssttuvv", "aaceiilnnoorsssttv",
     "abccfhllnooooorrru", "accdiiinnnoorssttt", "acceeiilmmnnoosttu",
     "acceiiimmnnnoorttu", "acdeeefhiimnnnrsst", "acefiiiilmnooprstv",
     "aciillnnnoostttuuy", "adeiilnooopprrstty", "aeeeiimnnoprrssstt",
     "aeehiiilnnoprrsstt", "aeeiiimnnoprrssttt", "ccdeiinnoorssstttu",
     "ceeilnnooorrsttuuv", "eeehiiiinprsssttvy"]
    |> Enum.into(HashSet.new)
  end
end
