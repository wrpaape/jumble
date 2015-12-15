defmodule Jumble.ScowlDict.Size35.Length2 do
  def get(string_id) do
    %{"fo" => ["of"], "ah" => ["ah", "ha"], "er" => ["re"], "su" => ["us"],
      "ap" => ["pa"], "ad" => ["ad"], "my" => ["my"], "cs" => ["cs"],
      "ms" => ["ms"], "ip" => ["pi"], "am" => ["ma", "am"], "ew" => ["we"],
      "eh" => ["eh", "he"], "pu" => ["up"], "ox" => ["ox"], "no" => ["no", "on"],
      "hi" => ["hi"], "as" => ["as"], "ho" => ["ho", "oh"], "mu" => ["mu"],
      "do" => ["do"], "at" => ["at"], "ot" => ["to"], "os" => ["so"],
      "go" => ["go"], "em" => ["em", "me"], "an" => ["an"], "in" => ["in"],
      "fi" => ["if"], "it" => ["it"], "be" => ["be"], "is" => ["is"],
      "by" => ["by"], "or" => ["or"], "di" => ["id"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["fo", "ah", "er", "su", "ap", "ad", "my", "cs", "ms", "ip", "am", "ew", "eh",
     "pu", "ox", "no", "hi", "as", "ho", "mu", "do", "at", "ot", "os", "go", "em",
     "an", "in", "fi", "it", "be", "is", "by", "or", "di"]
    |> Enum.into(HashSet.new)
  end
end
