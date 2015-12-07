defmodule Jumble.LengthDict.Length24 do
  def get(string_id) do
    %{"aacccgghhiillloooooppsty" => ["pathologicopsychological"],
      "aacdeehhiimoooprrrtttyyz" => ["thyroparathyroidectomize"],
      "aaddeeefhhlllmooprstuxyy" => ["formaldehydesulphoxylate"],
      "aadeeehhhiillnnooopprttt" => ["tetraiodophenolphthalein"],
      "acccefhhiiiiillnoooppsst" => ["scientificophilosophical"]}
    |> Map.get(string_id)
  end
end
