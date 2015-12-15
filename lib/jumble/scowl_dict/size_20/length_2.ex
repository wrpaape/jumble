defmodule Jumble.ScowlDict.Size20.Length2 do
  def get(string_id) do
    %{"ah" => ["ha"], "am" => ["am"], "an" => ["an"], "as" => ["as"],
      "at" => ["at"], "be" => ["be"], "by" => ["by"], "cs" => ["cs"],
      "di" => ["id"], "do" => ["do"], "eh" => ["eh", "he"], "em" => ["em", "me"],
      "er" => ["re"], "ew" => ["we"], "fi" => ["if"], "fo" => ["of"],
      "go" => ["go"], "ho" => ["ho", "oh"], "in" => ["in"], "ip" => ["pi"],
      "is" => ["is"], "it" => ["it"], "my" => ["my"], "no" => ["no", "on"],
      "or" => ["or"], "os" => ["so"], "ot" => ["to"], "pu" => ["up"],
      "su" => ["us"]}
    |> Map.get(string_id)
  end

  def valid_ids do
    ["ah", "am", "an", "as", "at", "be", "by", "cs", "di", "do", "eh", "em", "er",
     "ew", "fi", "fo", "go", "ho", "in", "ip", "is", "it", "my", "no", "or", "os",
     "ot", "pu", "su"]
    |> Enum.into(HashSet.new)
  end
end
