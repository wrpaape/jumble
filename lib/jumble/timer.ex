defmodule Jumble.Timer do
  # alias Jumble.PickTree
  # alias Jumble.BruteSolver
  @def_opts Map.new
    |> Map.put(:task,      {:task, fn -> end})
    |> Map.put(:ticker,    {:ticker_int, 100})
    |> Map.put(:countdown, {:timeout, 500})
    |> Map.put(:callback,  {:callback, fn -> end})

  @ticks = 3..5
  |> Enum.concat([2])
  |> Enum.flat_map(fn(level) ->
    [level, level + 6]
    |> Enum.map(&<<8590 + &1 :: utf8>>)
  end)
  |> Stream.cycle

  def monitor(opts) do
    # opts
    # |> fetch_args(:ticker)
    # |> build_named_agent(:ticker)
    # |> start_agent_task

    ticker

    # [ticker, countdown] =
    #   [:ticker, :countdown]
    #   |> Enum.map(fn(agent_name)->
    #     opts
    #     |> fetch_opts(agent_name)
    #     |> init_agent(agent_name)

    #     agent_name
    #     |> start_agent_task
    #   end)

    start_countdown
    |> Task.await

  end

  def fetch_opts(opts, agent_name) do
    {def_opt, def_val} =
      @def_opts
      |> Map.get(agent_name)

    opts 
    |> Keyword.get(def_opt, def_val)
  end

  # def get_agent_fun(name) do
  #   "start_"
  #   <> to_string(name)
  #   |> String.to_atom
  # end


  def init_agent(intial_state, name) do
    Agent.start_link(fn -> intial_state end, name: name)
  end

  def start_countdown do
    :countdown
    |> Agent.get_and_update(fn(timeout)->
      task =
        %Task{pid: task_pid} = 
          __MODULE__
          |> Task.async(:countdown, [timeout])
        {task, task_pid}
    end)
  end

  def reset_countdown do
    :countdown
    |> Agent.cast(__MODULE__, :reset_countdown, [])
  end

  def reset_countdown(countdown_pid) do
    countdown_pid
    |> send(:reset)

    countdown_pid
  end

  # def countdown(module, fun, args) do
  #   countdown =
  #     :countdown
  #     |> start_agent_task

  #   countdown
  #   |> Task.await
  # end


  def countdown(timeout) do
    receive do
      :reset ->
        countdown(timeout)
        exit(:normal)

      after timeout ->
        Agent.stop(:countdown)
    end
  end
end