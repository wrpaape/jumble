defmodule Jumble.ScowlDict.Size10.Length2 do
  def get(string_id) do
    %{"am" => ["am"], "an" => ["an"], "as" => ["as"], "at" => ["at"],
      "be" => ["be"], "by" => ["by"], "cs" => ["cs"], "do" => ["do"],
      "eh" => ["he"], "em" => ["me"], "er" => ["re"], "ew" => ["we"],
      "fi" => ["if"], "fo" => ["of"], "go" => ["go"], "ho" => ["oh"],
      "in" => ["in"], "ip" => ["pi"], "is" => ["is"], "it" => ["it"],
      "my" => ["my"], "no" => ["no", "on"], "or" => ["or"], "os" => ["so"],
      "ot" => ["to"], "pu" => ["up"], "su" => ["us"]}
    |> Map.get(string_id)
  end
end
