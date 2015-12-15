defmodule Jumble.ScowlDict.Size80.Length34 do
  def get(string_id) do
    %{"aaacccdeefgiiiiiiillloopprrssstuux" => ["supercalifragilisticexpialidocious"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aaacccdeefgiiiiiiillloopprrssstuux"]
    |> Enum.into(HashSet.new)
  end
end
