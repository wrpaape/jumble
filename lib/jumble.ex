defmodule Jumble do
  alias Jumble.Unjumbler
  alias Jumble.NLP
  alias Jumble.BruteSolver
  alias Jumble.ScowlDict

  # def report do
  #   :process_count
  #   |> :erlang.system_info
  #   |> IO.puts    
  # end

  def process do
    # 10
    # |> :timer.apply_interval(__MODULE__, :report, [])

    NLP.report_tokens
    
    Unjumbler.process

    ScowlDict.swap_dict

    BruteSolver.process
  end
end