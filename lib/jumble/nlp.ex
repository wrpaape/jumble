defmodule Jumble.NLP do
  alias Jumble.NLP.NLPParser

  def start_link(args = %{sol_info: %{clue: clue}}) do
    NLPParser
    |> Agent.start_link(:tokenize, [clue], name: __MODULE__)

    args
  end

  def process(clue) do
    clue
    |> IO.inspect
  end
end