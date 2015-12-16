defmodule Jumble.Countdown do
  alias Jumble.Helper
  alias Jumble.Ticker

  @timeout 10000
  @def_opts [
    prompt: "no prompt given!",
    ticker_int: 100,
    timeout: 1000,
    task: {IO, :puts, ["no task given!"]}
  ]

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def reset_countdown, do: Agent.cast(__MODULE__, &reset_countdown/1)

  def time_async(opts) do
    [prompt, ticker_int, timeout, {module, fun, args}] =
      opts
      |> fetch_args

    prompt
    |> IO.puts

    ticker_int
    |> Ticker.start

    __MODULE__
    |> Agent.start_link(:start_countdown, [timeout, self], name: __MODULE__)

    t1 = :erlang.timestamp

    module
    |> apply(fun, args)

    receive do
      :done ->
        time_elapsed =
          :erlang.timestamp
          |> :timer.now_diff(t1)

        __MODULE__
        |> Agent.stop(@timeout)

        Ticker.stop

      time_elapsed
    end
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

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


####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp fetch_args(opts) do
    @def_opts
    |> Enum.map(fn({key, default})->
      opts
      |> Keyword.get(key, default)
    end)
  end
end