defmodule Jumble.ScowlDict.Medium.Length2 do
  def get(string_id) do
    %{"af" => ["fa"], "al" => ["la"], "at" => ["ta"], "er" => ["er"],
      "es" => ["es"], "ex" => ["ex"], "ey" => ["ye"], "gs" => ["gs"],
      "hs" => ["sh"], "hu" => ["uh"], "im" => ["mi"], "io" => ["oi"],
      "it" => ["ti"], "ks" => ["ks"], "lo" => ["lo"], "ls" => ["ls"],
      "mu" => ["um"], "nu" => ["nu"], "ow" => ["ow"], "oy" => ["yo"],
      "rs" => ["rs"], "st" => ["ts"]}
    |> Map.get(string_id)
  end
end
