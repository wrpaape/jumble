defmodule Jumble.ScowlDict.Size60.Length22 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "aacceeeeghhllnoopprrty" => ["electroencephalography"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"]}
    |> Map.get(string_id)
  end
end
