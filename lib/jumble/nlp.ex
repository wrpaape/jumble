defmodule Jumble.NLP do
  alias Jumble.NLP.NLPParser

  def process(clue) do
    clue
    |> NLPParser.tokenize
    |> IO.inspect
    
  end
end