defmodule Jumble.ScowlDict.Size20.Length15 do
  def get(string_id) do
    %{"aacccehiirrsstt" => ["characteristics"],
      "aacgilnnoorsttu" => ["congratulations"],
      "aadeiilnorrrtxy" => ["extraordinarily"],
      "aadfghiorrrsttw" => ["straightforward"],
      "acdeeimmnnoorst" => ["recommendations"],
      "acdefiiilnnotty" => ["confidentiality"],
      "adghiinnnostttw" => ["notwithstanding"],
      "aeeeeinprrssttv" => ["representatives"],
      "aeeeiimnnoprttx" => ["experimentation"],
      "aeeeinnoprrsstt" => ["representations"],
      "aeeiilmmnnopstt" => ["implementations"],
      "aeeiinnoprrsttt" => ["interpretations"],
      "cceegiiinnnnnov" => ["inconveniencing"],
      "cceeiiinnnossst" => ["inconsistencies"],
      "eeegiimnnprrsst" => ["misrepresenting"],
      "eegiiimnnprrstt" => ["misinterpreting"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacccehiirrsstt", "aacgilnnoorsttu", "aadeiilnorrrtxy", "aadfghiorrrsttw",
     "acdeeimmnnoorst", "acdefiiilnnotty", "adghiinnnostttw", "aeeeeinprrssttv",
     "aeeeiimnnoprttx", "aeeeinnoprrsstt", "aeeiilmmnnopstt", "aeeiinnoprrsttt",
     "cceegiiinnnnnov", "cceeiiinnnossst", "eeegiimnnprrsst", "eegiiimnnprrstt"]
    |> Enum.into(HashSet.new)
  end
end
