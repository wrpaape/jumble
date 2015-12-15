defmodule Jumble.ScowlDict.Large.Length45 do
  def get(string_id) do
    %{"aacccccceeiiiiilllmmnnnnooooooooopprrsssstuuv" => ["pneumonoultramicroscopicsilicovolcanoconioses"],
      "aacccccceiiiiiilllmmnnnnooooooooopprrsssstuuv" => ["pneumonoultramicroscopicsilicovolcanoconiosis"]}
    |> Map.get(string_id)
  end
end
