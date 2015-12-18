defmodule Jumble.BruteSolver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Solver
  alias Jumble.BruteSolver.Printer
  alias Jumble.BruteSolver.Reporter 
  alias Jumble.Timer
  alias Jumble.ScowlDict

  @sol_spacer         ANSI.white <> " or\n "
  @letter_bank_lcap         "{ " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"

  @jumble_maps_key_path ~w(jumble_info jumble_maps)a

  @process_timer_opts [
    [
      prompt: ANSI.blue <> "picking valid ids for:\n\n ",
      task: {PickTree, :pick_valid_ids},
      callback: {PickTree, :dump_ids, []},
      timeout: 100,
      ticker_int: 17
    ],
    [
      prompt: ANSI.blue <> "ranking picks for:\n\n ",
      task: {ScowlDict, :rank_picks},
      timeout: 100,
      ticker_int: 17
    ],
    [
      prompt: ANSI.blue <> "solving for:\n\n ",
      task: {Solver, :solve_pick_batch},
      timeout: 100,
      ticker_int: 17
    ]
  ]

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)

    args
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    __MODULE__
    |> GenServer.cast({:push_unjumbled, jumble, unjumbled, key_letters})
  end

  def process, do: GenServer.cast(__MODULE__, :process)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(args) do
    args
    |> get_in(@jumble_maps_key_path)
    |> Enum.into(Map.new)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_cast({:push_unjumbled, jumble, unjumbled, key_letters}, jumble_maps) do
    jumble_maps
    |> update_in([jumble, :unjumbleds], &[{unjumbled, key_letters} | &1])
    |> Helper.wrap_prepend(:noreply)
  end

  def handle_cast(:process, jumble_maps) do
    jumble_maps
    |> process_unjumbleds
    |> pick_valid_ids
    |> rank_picks
    |> Solver.solve
    |> Helper.wrap_prepend(:noreply)
  end


  defp rank_picks(picks_info) do
    picks_info
    |> Enum.map(fn({letter_bank, unjumbleds_tup, rank_picks_timer_opts, inc_solve_timer_opts, num_picks})->
      rank_picks_timer_opts
      |> Timer.time_sync
      |> process_rankings(letter_bank, unjumbleds_tup, inc_solve_timer_opts, num_picks)
    end)
  end

  defp process_unjumbleds(jumble_maps) do
    jumble_maps
    |> Enum.sort_by(&(elem(&1, 1).jumble_index), &>=/2)
    |> Enum.map(fn({_jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Stats.combinations
    |> Enum.reduce(Map.new, fn(sol_combo, sols_by_letterbank) ->
      {letter_bank, unjumbleds} =
        sol_combo
        |> Enum.flat_map_reduce(ANSI.magenta, fn({unjumbled, key_letters}, unjumbleds) ->
          {key_letters, Helper.cap(" ", unjumbleds, unjumbled)}
        end)

      sols_by_letterbank
      |> Map.update(Enum.sort(letter_bank, &>=/2), [unjumbleds], &[unjumbleds | &1])
    end)
  end

  defp pick_valid_ids(unjumbleds_info) do
    unjumbleds_info
    |> Enum.reduce({[], 0}, fn({letter_bank, unjumbleds}, picks_tup)->
      letter_bank_string =
        letter_bank
        |> Enum.join(" ")
        |> Helper.cap(@letter_bank_lcap, @letter_bank_rcap)

      [inc_pick_tree_timer_opts | rem_inc_timer_opts] =
        unjumbleds
        |> complete_timer_prompts(letter_bank_string)

      inc_pick_tree_timer_opts
      |> append_task_args([letter_bank])
      |> Timer.time_async
      |> process_picks(letter_bank_string, rem_inc_timer_opts, unjumbleds, picks_tup)
    end)
    |> elem(0)
  end

  defp process_picks({time_elapsed, picks}, letter_bank_string, [inc_rank_picks_timer_opts, inc_solve_timer_opts], unjumbleds, {picks_info, total}) do
    num_uniqs =
      picks
      |> Set.size

    total = total + num_uniqs

    total
    |> Reporter.report_picks(num_uniqs, time_elapsed)

    if num_uniqs > 0 do
      unjumbleds_tup =
        unjumbleds
        |> Helper.wrap_append(length(unjumbleds))

      rank_picks_timer_opts =
        inc_rank_picks_timer_opts
        |> append_task_args([picks])

      pick_info = {ANSI.magenta <> letter_bank_string, unjumbleds_tup, rank_picks_timer_opts, inc_solve_timer_opts, num_uniqs}
      
      picks_info = [pick_info | picks_info]
    end

    {picks_info, total}
  end

  def process_rankings({time_elapsed, {ranked_picks, min_max_rank}}, letter_bank, unjumbleds_tup, inc_solve_timer_opts, num_picks) do
    solve_timer_opts =
      ranked_picks
      |> Enum.filter_map(&(elem(&1, 0) >= min_max_rank), fn({dict_size, {size_dict, picks, _count}})->

        inc_solve_timer_opts
        |> append_task_args([dict_size, size_dict, picks])
      end)

    {letter_bank, unjumbleds_tup, solve_timer_opts}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp complete_timer_prompts(unjumbleds, letter_bank_string) do
    unjumbleds_string = 
      unjumbleds
      |> Enum.join(@sol_spacer)

    prompt_suffix =
      "\n  " 
      |> Helper.cap(unjumbleds_string, letter_bank_string)

    @process_timer_opts
    |> Enum.map(fn(inc_timer_opts)->
      inc_timer_opts
      |> Keyword.update!(:prompt, &(&1 <> prompt_suffix))
    end)
  end

  defp append_task_args(inc_timer_opts, args) do
    inc_timer_opts
    |> Keyword.update!(:task, &Tuple.append(&1, args))
  end
end

