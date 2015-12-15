defmodule Jumble.ScowlDict.Size70.Length20 do
  def get(string_id) do
    %{"aaabcdehilnnnoorrtty" => ["tetrahydrocannabinol"],
      "aaacccehiillnrrsttuy" => ["uncharacteristically"],
      "aacccdeeghiilooprrrt" => ["electrocardiographic"],
      "aacceeeeghllmnooprrt" => ["electroencephalogram"],
      "aaccefgiiiillprrsstu" => ["supercalifragilistic"],
      "aacceghhilmooopprssy" => ["psychopharmacologies"],
      "aaccghhilmooopprssty" => ["psychopharmacologist"],
      "aacddeghimmnnoorstyy" => ["magnetohydrodynamics"],
      "aaceehiillnorssttuvy" => ["overenthusiastically"],
      "acdgghiiiinnnorssttu" => ["contradistinguishing"],
      "aceeilnnooorrrttuuvy" => ["counterrevolutionary"],
      "adeeiinnooopprrssstt" => ["disproportionateness"],
      "bceeeefikllmnnrrstuu" => ["buckminsterfullerene"],
      "deeeghiillmnooprrstu" => ["glomerulonephritides"]}
    |> Map.get(string_id)
  end
end