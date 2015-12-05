defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Stats
  alias Jumble.Helper
  alias Jumble.PickTree
  alias Jumble.Timer

  @ticker_interval 1000
  @pick_tree_timeout 500
  @unjumbled_sol_spacer ANSI.blue <> "solving for:\n\n  " <> ANSI.magenta
  @timer_callback fn ->
    __MODULE__
    |> :global.whereis_name
    |> send({:done, PickTree.get_results})
  end

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
      {word_bank, unjumbled_sol} =
        sol_combo
        |> Enum.flat_map_reduce(@unjumbled_sol_spacer, fn({unjumbled, key_letters}, unjumbled_sol) ->
          {key_letters, Helper.cap(" ", unjumbled_sol, unjumbled)}
        end)

      unjumbled_sol
      |> IO.write

      ticker =
        Task.async(&:timer.apply_interval(@ticker_interval, IO, :write, "  ."))
      
      @pick_tree_timeout
      |> Timer.start_link

      word_bank
      |> Enum.sort(&>=/2)
      |> PickTree.spawn_pickers

      receive do
        {:done, results} ->
          sol_combo
          |> Jumble.report_and_record(results)
      end
    end)
  end
end

