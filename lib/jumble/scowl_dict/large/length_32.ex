defmodule Jumble.ScowlDict.Large.Length32 do
  def get(string_id) do
    %{"accddeeehhhhiiilllnnooooprrrstty" => ["dichlorodiphenyltrichloroethanes"]}
    |> Map.get(string_id)
  end
end
