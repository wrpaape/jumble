defmodule Jumble.ScowlDict.Size80.Length32 do
  def get(string_id) do
    %{"accddeeehhhhiiilllnnooooprrrstty" => ["dichlorodiphenyltrichloroethanes"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["accddeeehhhhiiilllnnooooprrrstty"]
    |> Enum.into(HashSet.new)
  end
end
