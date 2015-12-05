defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Stats
  alias Jumble.Helper
  alias Jumble.PickTree
  alias Jumble.Timer

  @prompt_lcap Helper.cap("solving for:\n\n  ", ANSI.blue, ANSI.magenta)
  @prompt_rcap ANSI.white <> "   ..."

  @timer_opts Keyword.new
  |> Keyword.put(:timeout, 500)
  |> Keyword.put(:ticker_int, 1000)
  |> Keyword.put(:task, [PickTree, :get_results, []])
  |> Keyword.put(:callback, [PickTree, :get_results, []])

    

  def process, do: Agent.cast(__MODULE__, &process/1)

  def push_unjumbled(jumble, unjumbled, key_letters) do
    push_fun = fn(unjumbleds) ->
      [{unjumbled, key_letters} | unjumbleds]
    end

    __MODULE__
    |> Agent.cast(Kernel, :update_in, [[:jumble_info, :jumble_maps, jumble, :unjumbleds], push_fun])
  end

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Kernel
    |> Agent.start_link(:update_in, [args, [:jumble_info, :jumble_maps], into_map], name: __MODULE__)

    args
  end

  def process(%{jumble_info: %{jumble_maps: jumble_maps}}) do
    __MODULE__
    |> :global.register_name(self)

    jumble_maps
    |> Enum.sort_by(&(elem(&1, 1).jumble_index), &>=/2)
    |> Enum.map(fn({_jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Stats.combinations
    |> Enum.each(fn(sol_combo) ->
      {word_bank, prompt} =
        sol_combo
        |> Enum.flat_map_reduce(@prompt_lcap, fn({unjumbled, key_letters}, unjumbled_sol) ->
          {key_letters, Helper.cap(" ", unjumbled_sol, unjumbled)}
        end)

      # ticker =
      #   Task.async(&:timer.apply_interval(@ticker_interval, IO, :write, "  ."))
      
      # @timer_opts
      # |> Keyword.put(:ticker_msg, ticker_msg)
      # |> Timer.start_link

      prompt
      <> @prompt_rcap
      |> IO.puts

      # word_bank
      # |> Enum.sort(&>=/2)
      # |> PickTree.process


      Timer.start_link()

      countdown =
        Timer
        |> Task.await(:start_countdown, [@countdown_opts, &get_results/0])

      pick_valid_sols

      countdown
      |> Task.await

      get_results

      PickTree
      |> Task.await(:process, [Enum.sort(word_bank, &>=/2)])
      |> IO.puts

      # receive do
      #   {:done, results} ->
      #     sol_combo
      #     |> Jumble.report_and_record(results)
      # end
    end)
  end
end

