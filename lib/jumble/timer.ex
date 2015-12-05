defmodule Jumble.Timer do
  # alias Jumble.PickTree
  # alias Jumble.BruteSolver

  @ticks = 3..5
  |> Enum.concat([2])
  |> Enum.flat_map(fn(level) ->
    [level, level + 6]
    |> Enum.map(&<<8590 + &1 :: utf8>>)
  end)
  |> Stream.cycle

  def monitor(opts) do
    {countdown_args, next_opts} =
      [:timeout, :callback]
      |> Enum.map_reduce(init_opts, fn(opt_key, opts)->
        opts
        |> Keyword.pop_first(opt_key)
      end)

      countdown_agent =
        [__MODULE__, :countdown_agent, countdown_args, name: __MODULE__]


      countdown_task =
        Agent
        |> Task.async(:start_link, countdown_agent)
        

      # Agent.start_link(fn -> opts end, name: __MODULE__)

    # countdown = 
    #   __MODULE__
    #   |> Task.await(:countdown, countdown_args)


  end

  def start_link(opts), do: Agent.start_link(fn -> opts end, name: __MODULE__)

  def start_countdown,  do: Agent.cast(__MODULE__, &start_countdown/1)

  def reset_countdown,  do: Agent.cast(__MODULE__, &reset_countdown/1)

  def init(timer_opts) do
    # ticker = 
    #   Map.new
    # Map.new
    # |> Map.put(:timeout, timeout)
    # |> Map.put(:ticker, ticker_interval)
    # |> Map.put(:callback, callback)
  end

  def start_countdown(init_opts) do
    timeout = Keyword.split(init_opts, :timeout)

    

    __MODULE__
    |> spawn(:countdown, countdown_args)
    |> 
  end

  def reset_countdown(countdown_pid) do
    countdown_pid
    |> send(:reset)

    countdown_pid
  end

  def countdown(timeout, callback) do
    receive do
      :reset ->
        timeout
        |> countdown(callback)

        exit(:normal)

      after timeout ->
        callback
        |> apply
    end
  end
end