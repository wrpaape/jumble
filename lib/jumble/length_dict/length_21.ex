defmodule Jumble.LengthDict.Length21 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrt" => ["electroencephalograph"],
      "aacceeeeghllmnooprrst" => ["electroencephalograms"]}
    |> Map.get(string_id)
  end
end
