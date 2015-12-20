defmodule Jumble.Timer do
  alias Jumble.Ticker

  @master_timeout 10_000
  @async_opts [
    prompt: "no prompt given!",
    ticker_int: 100,
    timeout: 1000,
    task: {IO, :puts, ["no task given!"]},
    callback: {IO, :puts, ["no callback given!"]}
  ]
  @sync_opts [
    prompt: "no prompt given!",
    ticker_int: 100,
    task: {IO, :puts, ["no task given!"]}
  ]


##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def reset_countdown, do: Agent.cast(:countdown, &reset_countdown/1)

  def time_async(opts) do
    [prompt, ticker_int, timeout, task_tup, callback_tup] =
      opts
      |> fetch_args(@async_opts)

    prompt
    |> print_start(ticker_int)

    __MODULE__
    |> Agent.start_link(:start_countdown, [timeout, self], name: :countdown)

    start_time = :erlang.timestamp

    task_tup
    |> apply_fun_tup

    receive do
      :done ->
        time_elapsed =
          :erlang.timestamp
          |> :timer.now_diff(start_time)

        :countdown
        |> Agent.stop(@master_timeout)

        Ticker.stop

      {time_elapsed, apply_fun_tup(callback_tup)}
    end
  end

  def time_sync(opts) do
    [prompt, ticker_int, {module, fun, args}] =
      opts
      |> fetch_args(@sync_opts)

    prompt
    |> print_start(ticker_int)
    
    results =
      module
      |> :timer.tc(fun, args)

    Ticker.stop

    results
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
  
  defp print_start(prompt, ticker_int)do
    prompt
    |> IO.puts

    ticker_int
    |> Ticker.start
  end

  defp apply_fun_tup({module, fun, args}), do: apply(module, fun, args)

  defp fetch_args(opts, def_opts) do
    def_opts
    |> Enum.map_reduce(opts, fn({key, default}, opts)->
      opts
      |> Keyword.pop_first(key, default)
    end)
    |> elem(0)
  end
end