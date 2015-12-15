defmodule Jumble.ScowlDict.Size70.Length31 do
  def get(string_id) do
    %{"accddeeehhhhiiilllnnooooprrrtty" => ["dichlorodiphenyltrichloroethane"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["accddeeehhhhiiilllnnooooprrrtty"]
    |> Enum.into(HashSet.new)
  end
end
