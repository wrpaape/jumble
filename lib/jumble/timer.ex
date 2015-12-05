defmodule Jumble.Timer do
  @def_opts [
    ticker:   100,
    timeout:  500,
    task:     [fn -> end, []],
    callback: [fn -> end, []]
  ]

  @ticks 3..5
  |> Enum.concat([2])
  |> Enum.flat_map(fn(level) ->
    [level, level + 6]
    |> Enum.map(&<<8590 + &1 :: utf8>>)
  end)
  |> Stream.cycle

  

  def time_countdown(opts) do
    __MODULE__
    |> :timer.tc(:countdown, fetch_args(opts))
  end

  def fetch_args(opts) do
    @def_opts
    |> Enum.map(fn({key, default})->
      opts
      |> Keyword.get(key, default)
    end)
  end

  def countdown(ticker_int, timeout, task, callback) do
    ticker =
      __MODULE__
      |> Task.async(:ticker, ticker_int)

    countdown =
      timeout
      |> start_countdown

    Kernel
    |> apply(:apply, task)

    countdown
    |> Task.await

    [countdown, ticker]
    |> Enum.each(&Task.shutdown/2)

    Kernel
    |> apply(:apply, callback)
  end

  def ticker(ticker_int) do
    @ticks
    |> Enum.each(fn(tick)->
      tick
      <> "  "
      |> IO.write

      ticker_int
      |> :timer.sleep
    end)
  end


  def start_countdown(timeout) do
    Task
    |> Agent.start_link(:async, [__MODULE__, :countdown, [timeout]], name: :countdown)

    :countdown
    |> Agent.get_and_update(fn(task = %Task{pid: task_pid}) ->
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