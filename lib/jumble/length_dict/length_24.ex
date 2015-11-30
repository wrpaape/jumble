defmodule Jumble.LengthDict.Length24 do
  @length_24_length_dict %{"aacccgghhiillloooooppsty" => ["pathologicopsychological"],
                           "aacdeehhiimoooprrrtttyyz" => ["thyroparathyroidectomize"],
                           "aaddeeefhhlllmooprstuxyy" => ["formaldehydesulphoxylate"],
                           "aadeeehhhiillnnooopprttt" => ["tetraiodophenolphthalein"],
                           "acccefhhiiiiillnoooppsst" => ["scientificophilosophical"]}
  
  def get(string_id) do
    @length_24_length_dict
    |> Map.get(string_id)
  end
end
