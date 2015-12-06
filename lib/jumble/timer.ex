defmodule Jumble.Timer do
  alias IO.ANSI
  alias Jumble.Helper

  @def_opts [
    ticker:  100,
    timeout: 1000
  ]

  def time_countdown(opts) do
    __MODULE__
    |> :timer.tc(:countdown_process, fetch_args(opts))
  end

  def countdown_process(ticker_int, timeout, task, callback) do
    ticker =
      __MODULE__
      |> Task.async(:ticker, [ticker_int])

    timeout
    |> start_countdown

    task
    |> apply_funlist

    await_countdown

    ticker
    |> Task.shutdown

    callback
    |> apply_funlist
  end

  defp await_countdown do
    :countdown
    |> Agent.get(Task, :await, [])
  end

  defp tick_colors do
    ~w(red yellow green blue cyan magenta)a
    |> Enum.map(&apply(ANSI, &1, []))
  end

  defp ticks do
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


  def reset_countdown do
    :countdown
    |> Agent.cast(fn(task = %Task{pid: countdown_pid})->
      countdown_pid
      |> send(:reset)

      task
    end)
  end

  defp start_countdown(timeout) do
    Task
    |> Agent.start_link(:async, [__MODULE__, :countdown, [timeout]], name: :countdown)
  end

  def countdown(timeout) do
    receive do
      :reset ->
        countdown(timeout)
        exit(:normal)

      after timeout ->
        :done
    end
  end

  defp default_funs do
    [
      task:     [fn -> end, []],
      callback: [fn -> end, []]
    ]
  end

  defp fetch_args(opts) do
    @def_opts
    |> Enum.concat(default_funs)
    |> Enum.map(fn({key, default})->
      opts
      |> Keyword.get(key, default)
    end)
  end

  defp apply_funlist(fun_list), do: apply(Kernel, :apply, fun_list)
end