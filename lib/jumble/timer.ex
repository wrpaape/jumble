defmodule Jumble.Timer do
  alias IO.ANSI
  alias Jumble.Helper

  @def_opts [
    ticker:  100,
    timeout: 500
  ]
    
  def time_countdown(opts) do
    __MODULE__
    |> :timer.tc(:countdown, fetch_args(opts))
  end

  def default_funs do
    [
      task:     [fn -> end, []],
      callback: [fn -> end, []]
    ]
  end

  def fetch_args(opts) do
    @def_opts
    |> Enum.concat(default_funs)
    |> Enum.map(fn({key, default})->
      opts
      |> Keyword.get(key, default)
    end)
  end

  def countdown(ticker_int, timeout, task, callback) do
    ticker =
      __MODULE__
      |> Task.async(:ticker, [ticker_int])

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

  def tick_colors do
    ~w(red yellow green blue cyan magenta)a
    |> Enum.map(&apply(ANSI, &1, []))
  end

  def ticks do
    3..5
    |> Enum.concat([2])
    |> Enum.flat_map(fn(level) ->
      [level, level + 6]
      |> Enum.map(&<<8590 + &1 :: utf8>>)
    end)
  end

  def ticker(ticker_int) do
    tick_colors
    |> Stream.zip(ticks)
    |> Stream.cycle
    |> Enum.each(fn({color, tick})->

      color
      |> Helper.cap(ANSI.clear_line, tick)
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