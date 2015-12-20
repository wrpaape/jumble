defmodule Jumble.BruteSolver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Solver
  alias Jumble.BruteSolver.Reporter 
  alias Jumble.Timer
  alias Jumble.ScowlDict

  @sol_spacer         ANSI.white <> " or\n "
  @letter_bank_lcap         "{ " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"

  @jumble_maps_key_path ~w(jumble_info jumble_maps)a

  @process_timer_opts [
    [
      prompt: ANSI.cyan <> "picking valid ids for:\n\n ",
      task: {PickTree, :pick_valid_ids},
      callback: {PickTree, :dump_ids, []},
      timeout: 100,
      ticker_int: 17
    ],
    [
      prompt: ANSI.cyan <> "\n\nranking picks for:\n\n ",
      task: {ScowlDict, :rank_picks},
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

  def process do
    __MODULE__
    |> GenServer.call(:dump_jumble_maps)
    |> process
  end

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

  def handle_call(:dump_jumble_maps, _from, jumble_maps) do
    {:stop, :normal, jumble_maps, jumble_maps}
  end

  def process(jumble_maps) do
    jumble_maps
    |> process_unjumbleds
    |> pick_valid_ids
    |> rank_picks
    |> Solver.solve
  end


  defp rank_picks(picks_info) do
    picks_info
    |> Enum.map_reduce(0, fn({letter_bank, unjumbleds_tup, rank_picks_timer_opts, num_picks}, max_num_batches)->
      rank_picks_timer_opts
      |> Timer.time_sync
      |> process_rankings({letter_bank, unjumbleds_tup}, num_picks, max_num_batches)
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

      [inc_pick_tree_timer_opts , inc_rank_picks_timer_opts] =
        unjumbleds
        |> complete_timer_prompts(letter_bank_string)

      inc_pick_tree_timer_opts
      |> append_task_args([letter_bank])
      |> Timer.time_async
      |> process_picks(letter_bank_string, inc_rank_picks_timer_opts, unjumbleds, picks_tup)
    end)
    |> elem(0)
  end

  defp process_picks({time_elapsed, picks}, letter_bank_string, inc_rank_picks_timer_opts, unjumbleds, {picks_info, total}) do
    num_uniqs =
      picks
      |> Set.size

    total = total + num_uniqs

    num_uniqs
    |> Reporter.report_picks(total, time_elapsed)

    if num_uniqs > 0 do
      unjumbleds_tup =
        unjumbleds
        |> Helper.wrap_append(length(unjumbleds))

      rank_picks_timer_opts =
        inc_rank_picks_timer_opts
        |> append_task_args([picks])

      pick_info = {ANSI.magenta <> letter_bank_string, unjumbleds_tup, rank_picks_timer_opts, num_uniqs}
      
      picks_info = [pick_info | picks_info]
    end

    {picks_info, total}
  end

  def collapse_rankings(ranked_picks, min_max_rank) do
    ranked_picks
    |> Enum.drop_while(&(elem(&1, 0) < min_max_rank))
    |> List.foldr({[], 0, 0}, fn
      ({_dict_size, {_getters, _picks, dup_count}}, last_batch_tup = {_sol_batches, _num_batches, dup_count})->
        last_batch_tup
      ({_dict_size, {getters, picks, count}}, {sol_batches, num_batches, _last_count})->
        {[{getters, picks} | sol_batches], num_batches + 1, count}
    end)
    |> Tuple.delete_at(2)
  end

  def process_rankings({time_elapsed, {ranked_picks, min_max_rank}}, printer_tup, total_picks, max_num_batches) do
    ranked_picks
    |> Reporter.report_rankings(total_picks, time_elapsed)

    {batches, num_batches} =
      ranked_picks
      |> collapse_rankings(min_max_rank)

    {{printer_tup, batches}, max(max_num_batches, num_batches)}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def append_task_args(inc_timer_opts, args) do
    inc_timer_opts
    |> Keyword.update!(:task, &Tuple.append(&1, args))
  end

  def append_prompt_suffix(inc_timer_opts, prompt_suffix) do
    inc_timer_opts
    |> Keyword.update!(:prompt, &(&1 <> prompt_suffix))
  end

  defp complete_timer_prompts(unjumbleds, letter_bank_string) do
    unjumbleds_string = 
      unjumbleds
      |> Enum.join(@sol_spacer)

    prompt_suffix =
      "\n  " 
      |> Helper.cap(unjumbleds_string, letter_bank_string)

    @process_timer_opts
    |> Enum.map(&append_prompt_suffix(&1, prompt_suffix))
  end
end

