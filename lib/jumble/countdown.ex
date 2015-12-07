defmodule Jumble.Countdown do
  alias IO.ANSI
  alias Jumble.Helper

  @def_opts [
    ticker_int:  100,
    timeout: 1000,
    task: {IO, :puts, ["no task given!"]},
  ]

  def reset_countdown, do: Agent.cast(:countdown, &reset_countdown/1)

  # def time_async({module, fun, args}, timeout, ticker_int) do
  def time_async(opts) do
    [ticker_int, timeout, {module, fun, args}] =
      opts
      |> fetch_args 

    ticker =
      __MODULE__
      |> Task.async(:ticker, [ticker_int])

    __MODULE__
    |> Agent.start_link(:start_countdown, [timeout, self], name: :countdown)

    t1 = :erlang.timestamp

    module
    |> apply(fun, args)

    receive do
      :done ->
        time_elapsed =
          :erlang.timestamp
          |> :timer.now_diff(t1)

        :countdown
        |> Agent.stop

        ticker
        |> Task.shutdown

        ANSI.clear_line
        |> IO.write

      time_elapsed
    end
  end

  def reset_countdown({timer_ref, timeout, master_pid}) do
    timer_ref
    |> :timer.cancel

    timeout
    |> start_countdown(master_pid)
  end

  def start_countdown(timeout, master_pid) do
    {:ok, timer_ref} =
      timeout
      |> :timer.send_after(master_pid, :done)

    {timer_ref, timeout, master_pid}
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

  defp fetch_args(opts) do
    @def_opts
    |> Enum.map(fn({key, default})->
      opts
      |> Keyword.get(key, default)
    end)
  end
end