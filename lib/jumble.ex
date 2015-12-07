defmodule Jumble do
  alias Jumble.Unjumbler
  alias Jumble.NLP
  alias Jumble.BruteSolver

  def process do
    NLP.report_tokens
    
    Unjumbler.process

    BruteSolver.process
  end
end