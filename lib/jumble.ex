defmodule Jumble do
  alias IO.ANSI
  alias Jumble.Unjumbler
  alias Jumble.NLP
  alias Jumble.BruteSolver
  alias Jumble.Helper

  def process do
    Unjumbler.process

    NLP.report_tokens

    BruteSolver.process
  end

  # def report_and_record(unjumbled_sol, next_results) do
  #   next_results
  #   |> length
  #   |> Integer.to_string
  #   |> Helper.cap(@clue_sol_spacer, " unique running solutions\n")
  #   |> IO.puts

  #   __MODULE__
  #   |> Agent.update(fn(all_results)->
  #     all_results
  #     |> Map.put(unjumbled_sol, next_results)
  #   end)
  # end
end