defmodule Jumble.ScowlDict.Size60.Length22 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "aacceeeeghhllnoopprrty" => ["electroencephalography"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacceeeeghhllnoopprrst", "aacceeeeghhllnoopprrty", "aceeeiilnnooorrrsttuuv"]
    |> Enum.into(HashSet.new)
  end
end
