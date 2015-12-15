defmodule Jumble.ScowlDict.Size40.Length19 do
  def get(string_id) do
    %{"acefiiiilmnooprsstv" => ["oversimplifications"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["acefiiiilmnooprsstv"]
    |> Enum.into(HashSet.new)
  end
end
