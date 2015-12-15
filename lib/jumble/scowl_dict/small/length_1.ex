defmodule Jumble.ScowlDict.Small.Length1 do
  def get(string_id) do
    %{"a" => ["a"], "m" => ["m"]}
    |> Map.get(string_id)
  end
end
