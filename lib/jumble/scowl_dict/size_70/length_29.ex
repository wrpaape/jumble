defmodule Jumble.ScowlDict.Size70.Length29 do
  def get(string_id) do
    %{"aaaabdeehiiiiilmmnnnrsssssttt" => ["antidisestablishmentarianisms"],
      "aaccccffhiiiiiiiiilllnnnooptu" => ["floccinaucinihilipilification"]}
    |> Map.get(string_id)
  end
end