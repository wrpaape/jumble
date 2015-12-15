defmodule Jumble.ScowlDict.Size50.Length18 do
  def get(string_id) do
    %{"aaabiinnnorssttttu" => ["transubstantiation"],
      "aaacccehiillrrstty" => ["characteristically"],
      "aaccdeeghilooprrrt" => ["electrocardiograph"],
      "aaccdeegilmoorrrst" => ["electrocardiograms"],
      "aacdeeilnnnrsssttt" => ["transcendentalists"],
      "aaceeilnorrssttuvv" => ["ultraconservatives"],
      "aaceiilnnoorsssttv" => ["conversationalists"],
      "abccfhllnooooorrru" => ["chlorofluorocarbon"],
      "accdiiinnnoorssttt" => ["contradistinctions"],
      "acceeiilmmnnoosttu" => ["telecommunications"],
      "acdeeefhiimnnnrsst" => ["disenfranchisement"],
      "acefiiiilmnooprstv" => ["oversimplification"],
      "adeiilnooopprrstty" => ["disproportionately"],
      "aeeeiimnnoprrssstt" => ["misrepresentations"],
      "aeehiiilnnoprrsstt" => ["interrelationships"],
      "aeeiiimnnoprrssttt" => ["misinterpretations"],
      "ceeilnnooorrsttuuv" => ["counterrevolutions"],
      "eeehiiiinprsssttvy" => ["hypersensitivities"]}
    |> Map.get(string_id)
  end
end
