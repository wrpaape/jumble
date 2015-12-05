defmodule Jumble.Timer do
  alias Jumble.PickTree
  alias Jumble.BruteSolver

  def start_link(timer_specs) do
    __MODULE__
    |> Agent.start_link(:init, timer_specs, name: __MODULE__)

  def start_countdown,     do: Agent.cast(__MODULE__, &start_countdown/1)

  def reset_countdown,     do: Agent.cast(__MODULE__, &reset_countdown/1)

  def init({timeout, ticker_interval, ticker_prompt, callback}) do
    ticker = 
      Map.new
    Map.new
    |> Map.put(:timeout, timeout)
    |> Map.put(:ticker, ticker_interval)
    |> Map.put(:callback, callback)
  end

  def start_countdown(timeout) do
    __MODULE__
    |> spawn(:countdown, [timeout])
  end

  def reset_countdown(countdown_pid) do
    countdown_pid
    |> send(:reset)

    countdown_pid
  end

  def countdown(timeout) do
    receive do
      :reset ->
        countdown(timeout)

        exit(:normal)

      after timeout ->
        __MODULE__
        |> Agent.stop
        
        BruteSolver
        |> :global.whereis_name
        |> send({:done, PickTree.get_results})
    end
  end
end