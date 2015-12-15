defmodule Jumble.ScowlDict.Size60.Length18 do
  def get(string_id) do
    %{"aaabcghiillooprtuy" => ["autobiographically"],
      "aaabiinnnorssttttu" => ["transubstantiation"],
      "aaacccehiillrrstty" => ["characteristically"],
      "aaacchilllnopstyyy" => ["psychoanalytically"],
      "aabceeeghilnnnnort" => ["noninterchangeable"],
      "aabceeghiiilnnrtty" => ["interchangeability"],
      "aaccdeeghilooprrrt" => ["electrocardiograph"],
      "aaccdeegilmoorrrst" => ["electrocardiograms"],
      "aacdeeilnnnrsssttt" => ["transcendentalists"],
      "aaceeilnorrssttuvv" => ["ultraconservatives"],
      "aaceggiilnnoorsstt" => ["congregationalists"],
      "aaceiilnnoorsssttv" => ["conversationalists"],
      "aacfgiiimnnoorrstt" => ["transmogrification"],
      "abccfhllnooooorrru" => ["chlorofluorocarbon"],
      "accdiiinnnoorssttt" => ["contradistinctions"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "accegiiimmnnnorttu" => ["intercommunicating"],
      "acceiiimmnnnoorttu" => ["intercommunication"],
      "acdeeefhiimnnnrsst" => ["disenfranchisement"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "aceiiiiinnosstttvv" => ["antivivisectionist"],
      "aciillnnnoostttuuy" => ["unconstitutionally"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeeeemnnooprssstux" => ["extemporaneousness"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"],
      "aeehiiilnnoprrsstt" => ["interrelationships"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"],
      "ccdeiinnoorssstttu" => ["deconstructionists"],
      "ceeilnnooorrsttuuv" => ["counterrevolutions"],
      "eeeehiinnprsssstvy" => ["hypersensitiveness"],
      "eeehiiiinprsssttvy" => ["hypersensitivities"]}
    |> Map.get(string_id)
  end
end
