defmodule Jumble.ScowlDict.Size95.Length1 do
  def get(string_id) do
    %{"a" => ["a"], "b" => ["b"], "c" => ["c"], "d" => ["d"], "e" => ["e"],
      "f" => ["f"], "g" => ["g"], "h" => ["h"], "i" => ["i"], "j" => ["j"],
      "k" => ["k"], "l" => ["l"], "m" => ["m"], "n" => ["n"], "o" => ["o"],
      "p" => ["p"], "q" => ["q"], "r" => ["r"], "s" => ["s"], "t" => ["t"],
      "u" => ["u"], "v" => ["v"], "w" => ["w"], "x" => ["x"], "y" => ["y"],
      "z" => ["z"]}
    |> Map.get(string_id)
  end
end
