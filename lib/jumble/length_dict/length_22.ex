defmodule Jumble.LengthDict.Length22 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"]}
    |> Map.get(string_id)
  end
end
