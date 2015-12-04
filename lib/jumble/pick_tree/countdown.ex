defmodule Jumble.PickTree.Countdown do
  alias Jumble.Helper
  alias Jumble.PickTree
  alias Jumble.Solver

  def start_link(caller_pid, timeout) do
    Agent.start_link(fn -> {timeout, caller_pid} end, name: __MODULE__)
  end

  def start_countdown,     do: Agent.cast(__MODULE__, &start_countdown/1)

  def reset_countdown,     do: Agent.cast(__MODULE__, &reset_countdown/1)


  def start_countdown({timeout, caller_pid}) do
    __MODULE__
    |> spawn(:countdown, [timeout, caller_pid])
    |> Helper.wrap_prepend(caller_pid)
  end

  def reset_countdown(state = {_caller_pid, countdown_pid}) do
    countdown_pid
    |> send(:reset)

    state
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