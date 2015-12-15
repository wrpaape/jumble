defmodule Jumble.ScowlDict.Size80.Length45 do
  def get(string_id) do
    %{"aacccccceiiiiiilllmmnnnnooooooooopprrsssstuuv" => ["pneumonoultramicroscopicsilicovolcanoconiosis"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacccccceiiiiiilllmmnnnnooooooooopprrsssstuuv"]
    |> Enum.into(HashSet.new)
  end
end
