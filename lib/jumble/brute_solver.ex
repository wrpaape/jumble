defmodule Jumble.BruteSolver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Solver
  alias Jumble.BruteSolver.Printer
  alias Jumble.BruteSolver.Reporter
  alias Jumble.Countdown
  alias Jumble.ScowlDict

  @sol_spacer         ANSI.white <> " or\n "
  @letter_bank_lcap         "{ " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"

  @jumble_maps_key_path ~w(jumble_info jumble_maps)a

  @process_timer_opts [
    [
      prompt: ANSI.blue <> "picking valid ids for:\n\n ",
      task: {PickTree, :pick_valid_ids},
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
      task: {Solver, :solve},
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
    |> Helper.wrap_prepend(:noreply)
  end


  defp rank_picks({total, max_group_size, picks_info}) do
    picks_info
    |> Enum.each(fn({letter_bank, [inc_rank_picks_timer_opts | rem_inc_timer_opts], unjumbleds_tup, num_uniqs, picks})->
      inc_rank_picks_timer_opts
      |> append_task_args([picks])
      |> Countdown.time_async
      |> IO.inspect
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
    |> Enum.reduce({0, 0, []}, fn({letter_bank, unjumbleds}, picks_tup)->
      letter_bank_string =
        letter_bank
        |> Enum.join(" ")
        |> Helper.cap(@letter_bank_lcap, @letter_bank_rcap)

      [inc_pick_tree_timer_opts | rem_inc_timer_opts] =
        unjumbleds
        |> complete_timer_prompts(letter_bank_string)

      inc_pick_tree_timer_opts
      |> append_task_args([letter_bank])
      |> Countdown.time_async
      |> process_picks(letter_bank_string, rem_inc_timer_opts, unjumbleds, PickTree.dump_ids, picks_tup)
    end)
  end

  defp process_picks(time_elapsed, letter_bank_string, rem_inc_timer_opts, unjumbleds, picks, {total, max_group_size, picks_info}) do
    num_uniqs =
      picks
      |> Set.size

    total = total + num_uniqs

    total
    |> Reporter.report_picks(num_uniqs, time_elapsed)

    if num_uniqs > 0 do
      group_size =
        unjumbleds
        |> length

      unjumbleds_tup =
        unjumbleds
        |> Helper.wrap_append(group_size)

      pick_info = {ANSI.magenta <> letter_bank_string, rem_inc_timer_opts, unjumbleds_tup, num_uniqs, picks}
      
      max_group_size =
        max_group_size
        |> max(group_size)

      picks_info = [pick_info | picks_info]
    end

    {total, max_group_size, picks_info}
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

  # @jumble_maps_key_path      ~w(jumble_info jumble_maps)a
  # @letter_bank_info_key_path ~w(sol_info letter_bank_info)a
  # @sols_key_path             ~w(sol_info brute sols)a
  # @total_key_path            ~w(sol_info brute counts total)a
  # @max_group_size_key_path   ~w(sol_info brute counts max_group_size)a

  # @show_num_results 10

  # defp push_in_agent(key_path, el) do
  #   update_in_agent(key_path, &[el | &1])
  # end

  # defp get_in_agent(key_path) do
  #   __MODULE__
  #   |> Agent.get(Kernel, :get_in, [key_path])
  # end


  # defp put_in_agent(key_path, value) do
  #   __MODULE__
  #   |> Agent.update(Kernel, :put_in, [key_path, value])
  # end

  # defp update_in_agent(key_path, fun) do
  #   __MODULE__
  #   |> Agent.cast(Kernel, :update_in, [key_path, fun])
  # end

  # defp get_and_inc_in_agent(key_path, inc) do
  #   __MODULE__
  #   |> Agent.get_and_update(Kernel, :get_and_update_in, [key_path, &Tuple.duplicate(&1 + inc, 2)])
  # end


