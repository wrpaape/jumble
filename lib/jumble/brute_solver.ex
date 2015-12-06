defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Stats
  alias Jumble.Helper
  alias Jumble.PickTree
  alias Jumble.Timer

  @prompt_lcap Helper.cap("solving for:\n\n  ", ANSI.blue, ANSI.magenta)
  @prompt_rcap ANSI.white <> "   ..."

  @timer_opts [
    ticker_int: 1000,
    timeout: 500,
    task: [PickTree, :pick_valid_sols],
    callback: [PickTree, :get_results, []]
  ]

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Kernel
    |> Agent.start_link(:update_in, [args, [:jumble_info, :jumble_maps], into_map], name: __MODULE__)

    args
  end

  def process, do: Agent.cast(__MODULE__, __MODULE__, :process, [])

  def push_unjumbled(jumble, unjumbled, key_letters) do
    push_fun = fn(unjumbleds) ->
      [{unjumbled, key_letters} | unjumbleds]
    end

    __MODULE__
    |> Agent.cast(Kernel, :update_in, [[:jumble_info, :jumble_maps, jumble, :unjumbleds], push_fun])
  end


  def update_timer_opts(word_bank) do
    @timer_opts
    |> Keyword.update!(:task, &List.insert_at(&1, -1, [word_bank]))
  end

  def process(%{jumble_info: %{jumble_maps: jumble_maps}}) do
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

      prompt
      <> @prompt_rcap
      |> IO.puts

      word_bank
      |> Enum.sort(&>=/2)
      |> update_timer_opts
      |> Timer.time_countdown
      |> IO.puts
    end)
  end
end

