defmodule Jumble.ScowlDict.Size70.Length21 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrt" => ["electroencephalograph"],
      "aacceeeeghllmnooprrst" => ["electroencephalograms"],
      "aaccefhiilllnosstuuyz" => ["succinylsulfathiazole"],
      "acceeeiimmnnnossstuuv" => ["uncommunicativenesses"],
      "aceeeemnnnoooprsssstu" => ["contemporaneousnesses"],
      "addeehhiimmoopprrsstu" => ["pseudohermaphroditism"],
      "agghiillnnooooorrstty" => ["otorhinolaryngologist"],
      "bceeiiiiilnnoorrstttv" => ["incontrovertibilities"],
      "cceeefilnnnoossssssuu" => ["unselfconsciousnesses"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacceeeeghhllnoopprrt", "aacceeeeghllmnooprrst", "aaccefhiilllnosstuuyz",
     "acceeeiimmnnnossstuuv", "aceeeemnnnoooprsssstu", "addeehhiimmoopprrsstu",
     "agghiillnnooooorrstty", "bceeiiiiilnnoorrstttv", "cceeefilnnnoossssssuu"]
    |> Enum.into(HashSet.new)
  end
end
