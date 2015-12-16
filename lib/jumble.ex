defmodule Jumble do
  alias Jumble.Unjumbler
  alias Jumble.NLP
  alias Jumble.BruteSolver
  alias Jumble.ScowlDict

  def process do
    NLP.report_tokens
    
    Unjumbler.process

    ScowlDict.swap_dicts

    BruteSolver.process
  end
end