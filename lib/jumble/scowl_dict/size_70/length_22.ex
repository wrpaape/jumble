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
end
