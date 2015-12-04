defmodule Jumble.Solver do
  @pick_tree_timeout 500

  alias IO.ANSI
  alias Jumble.Stats
  alias Jumble.Helper
  alias Jumble.PickTree

  @unjumbled_sol_spacer "unscrambling for:\n  "   <> ANSI.magenta
  @clue_sol_spacer       "\n    "                 <> ANSI.cyan

  def solve do
    __MODULE__
    |> Agent.cast(&solve/1)
  end

  def resume, do: Agent.cast(__MODULE__, :start_countdown)

  def push_unjumbled(jumble, unjumbled, key_letters) do
    push = fn(unjumbleds) ->
      [{unjumbled, key_letters} | unjumbleds]
    end

    __MODULE__
    |> Agent.cast(Kernel, :update_in, [[:jumble_info, :jumble_maps, jumble, :unjumbleds], push])
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

  def solve(%{jumble_info: %{jumble_maps: jumble_maps}}) do
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

      IO.puts unjumbled_sol
      
      @idle_timeout
      |> Countdown.start_link

      word_bank
      |> Enum.sort(&>=/2)
      |> PickTree.spawn_pickers

      receive do
        {:done, results} -> IO.inspect(length(results))

        after 5000 -> IO.puts "DED"
      end
    end)
  end
end

