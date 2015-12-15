defmodule Jumble.ScowlDict.Size95.Length45 do
  def get(string_id) do
    %{"aacccccceeiiiiilllmmnnnnooooooooopprrsssstuuv" => ["pneumonoultramicroscopicsilicovolcanoconioses"],
      "aacccccceiiiiiilllmmnnnnooooooooopprrsssstuuv" => ["pneumonoultramicroscopicsilicovolcanoconiosis"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacccccceeiiiiilllmmnnnnooooooooopprrsssstuuv",
     "aacccccceiiiiiilllmmnnnnooooooooopprrsssstuuv"]
    |> Enum.into(HashSet.new)
  end
end
