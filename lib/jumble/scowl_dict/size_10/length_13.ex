defmodule Jumble.ScowlDict.Size10.Length13 do
  def get(string_id) do
    %{"aaacillmottuy" => ["automatically"], "aaceilmoprtvy" => ["comparatively"],
      "aaddeegnrrtuu" => ["undergraduate"], "aadefllmnntuy" => ["fundamentally"],
      "aaeeillnrttvy" => ["alternatively"], "aaeiilnnnortt" => ["international"],
      "abciiilmoptty" => ["compatibility"], "abeehilmnsstt" => ["establishment"],
      "accceimnrsstu" => ["circumstances"], "acciimmnnootu" => ["communication"],
      "acdehiiopsstt" => ["sophisticated"], "acdeiinnoorst" => ["consideration"],
      "acdeimnnoottu" => ["documentation"], "aceeilnnrssuy" => ["unnecessarily"],
      "acehiiopssstt" => ["sophisticates"], "acfgiiilnnsty" => ["significantly"],
      "acfiiijnosttu" => ["justification"], "addeginnnrstu" => ["understanding"],
      "addeimnnrsstu" => ["misunderstand"], "adeimnnoorstt" => ["demonstration"],
      "aeflnnorttuuy" => ["unfortunately"], "bciinnoorsttu" => ["contributions"],
      "beiiiilopssst" => ["possibilities"], "cceeeiinnnnov" => ["inconvenience"],
      "ceeehimnoprsv" => ["comprehensive"], "ddeeeilnnnpty" => ["independently"],
      "ddeimnoorsstu" => ["misunderstood"], "eiinoopprsttu" => ["opportunities"]}
    |> Map.get(string_id)
  end
end
