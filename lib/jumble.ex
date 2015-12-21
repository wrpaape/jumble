defmodule Jumble do
  alias Jumble.Unjumbler
  alias Jumble.NLP
  alias Jumble.BruteSolver
  alias Jumble.ScowlDict

  def report_processes do: :timer.apply_interval(10, __MODULE__, :report, [])
  def report do
    :process_count
    |> :erlang.system_info
    |> IO.puts    
  end

  def process do
    # report_processes

    NLP.report_tokens
    
    Unjumbler.process

    ScowlDict.swap_dict

    BruteSolver.process
  end
end
