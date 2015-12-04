defmodule Jumble.PickTree.Countdown do
  alias Jumble.PickTree
  alias Jumble.Solver

  def start_link(timeout), do: Agent.start_link(fn -> timeout end, name: __MODULE__)

  def start_countdown,     do: Agent.cast(__MODULE__, &start_countdown/1)

  def reset_countdown,     do: Agent.cast(__MODULE__, &reset_countdown/1)


  def start_countdown(timeout) do
    __MODULE__
    |> spawn(:countdown, timeout)
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
        Solver
        |> :global.whereis_name
        |> send({:done, PickTree.get_results})

        __MODULE__
        |> Agent.stop
    end
  end
end