defmodule Jumble.LengthDict.Length18 do
  def get(string_id) do
    %{"aaabiinnnorssttttu" => ["transubstantiation"],
      "aaacccehiillrrstty" => ["characteristically"],
      "aaccdeeghilooprrrt" => ["electrocardiograph"],
      "aaccdeegilmoorrrst" => ["electrocardiograms"],
      "aacceiilnnoopssttu" => ["conceptualisations"],
      "aacceiilnnoopsttuz" => ["conceptualizations"],
      "aacdeeilnnnrsssttt" => ["transcendentalists"],
      "aaceeilnorrssttuvv" => ["ultraconservatives"],
      "aaceggiilnnoorsstt" => ["congregationalists"],
      "aacegiilmmnnoprstt" => ["compartmentalising"],
      "aacegiilmmnnoprttz" => ["compartmentalizing"],
      "aaceiilnnoorsssttv" => ["conversationalists"],
      "aaeeghiilnoosssstt" => ["anaesthesiologists"],
      "aaegiiiilnnnnorstt" => ["internationalising"],
      "aaegiiiilnnnnorttz" => ["internationalizing"],
      "abccfhllnooooorrru" => ["chlorofluorocarbon"],
      "accdiiinnnoorssttt" => ["contradistinctions"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "acdeeefhiimnnnrsst" => ["disenfranchisement"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"],
      "aeehiiilnnoprrsstt" => ["interrelationships"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"],
      "agiiiiilnnnosstttu" => ["institutionalising"],
      "agiiiiilnnnostttuz" => ["institutionalizing"],
      "ceeilnnooorrsttuuv" => ["counterrevolutions"],
      "eeehiiiinprsssttvy" => ["hypersensitivities"]}
    |> Map.get(string_id)
  end
end
