defmodule Jumble.ScowlDict.Size55.Length22 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacceeeeghhllnoopprrst", "aceeeiilnnooorrrsttuuv"]
    |> Enum.into(HashSet.new)
  end
end
