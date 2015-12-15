defmodule Jumble.ScowlDict.Size70.Length22 do
  def get(string_id) do
    %{"aacceeeeghhllnoopprrst" => ["electroencephalographs"],
      "aacceeeeghhllnoopprrty" => ["electroencephalography"],
      "aadeiiiiilnnnoosttttuz" => ["deinstitutionalization"],
      "aaeeeeeehhilmmnnrtttxy" => ["hexamethylenetetramine"],
      "aceeeiilnnooorrrsttuuv" => ["counterrevolutionaries"],
      "agghiillnnooooorrsstty" => ["otorhinolaryngologists"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["aacceeeeghhllnoopprrst", "aacceeeeghhllnoopprrty", "aadeiiiiilnnnoosttttuz",
     "aaeeeeeehhilmmnnrtttxy", "aceeeiilnnooorrrsttuuv", "agghiillnnooooorrsstty"]
    |> Enum.into(HashSet.new)
  end
end
