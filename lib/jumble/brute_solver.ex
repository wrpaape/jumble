defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Solver
  alias Jumble.BruteSolver.Printer
  alias Jumble.Countdown
  alias Jumble.ScowlDict

  @sol_spacer    ANSI.white <> " or\n "
  @report_indent "\n" <> Helper.pad(4)
  @letter_bank_lcap         "{ " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"
  @continue_prompt "\n\n  continue? (y/n)\n  "
    |> Helper.cap(ANSI.white, ANSI.blink_slow)
    |> Helper.cap(ANSI.black_background, "> " <> ANSI.blink_off)

  @jumble_maps_key_path      ~w(jumble_info jumble_maps)a
  @letter_bank_info_key_path ~w(sol_info letter_bank_info)a
  @sols_key_path             ~w(sol_info brute sols)a
  @counts_key_path           ~w(sol_info brute counts)a
  @total_key_path            ~w(sol_info brute counts total)a
  @max_group_size_key_path   ~w(sol_info brute counts max_group_size)a
  @rem_continues_key_path    ~w(sol_info rem_continues)a
  
  @num_scowl_dicts Application.get_env(:jumble, :num_scowl_dicts)
  @show_num_results 10
  @process_timer_opts [
    [
      prompt: ANSI.blue <> "picking for:\n\n "
      task: {PickTree, :pick_valid_ids},
      timeout: 1000,
      ticker_int: 17
    ],
    [
      timer_opts: [
        prompt: ANSI.blue <> "solving for:\n\n "
        task: {Solver, :solve},
        timeout: 1000,
        ticker_int: 17
      ]
    ]
  ]

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Kernel
    |> Agent.start_link(:update_in, [args, [:jumble_info, :jumble_maps], into_map], name: __MODULE__)

    @rem_continues_key_path
    |> put_in_agent(@num_scowl_dicts - 1)

    args
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    [:jumble_info, :jumble_maps, jumble, :unjumbleds]
    |> push_in_agent({unjumbled, key_letters})
  end

  def process do
    @jumble_maps_key_path
    |> get_in_agent
    |> retreive_letter_bank_info
    |> brute_solve
  end

  def request_continue do
    @continue_prompt
    |> IO.gets
    |> String.match?(~r/y/i)
    |> if do
      ScowlDict.update_limit

      solve_next
    end
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
  defp brute_solve(letter_bank_info) do
    @letter_bank_info_key_path
    |> put_in_agent(letter_bank_info)

    solve_next
  end

  defp solve_next do
    if decrement_continues > 0 do
      @letter_bank_info_key_path
      |> get_in_agent
      |> Enum.each(fn({letter_bank_string, timer_opts, unjumbleds_tup})->
        timer_opts
        |> Countdown.time_async
        |> report_and_record(letter_bank_string, unjumbleds_tup, PickTree.dump_ids)
      end)

      @sols_key_path
      |> get_in_agent
      |> Printer.print_solutions(get_in_agent(@max_group_size_key_path))

      request_continue
    end
  end

  defp retreive_letter_bank_info(jumble_maps) do
    jumble_maps
    |> Enum.sort_by(&(elem(&1, 1).jumble_index), &>=/2)
    |> Enum.map(fn({_jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Stats.combinations
    |> Enum.reduce(Map.new, fn(sol_combo, sols_by_letterbank) ->
      {letter_bank, unjumbled_sols} =
        sol_combo
        |> Enum.flat_map_reduce(ANSI.magenta, fn({unjumbled, key_letters}, unjumbled_sols) ->
          {key_letters, Helper.cap(" ", unjumbled_sols, unjumbled)}
        end)

      sols_by_letterbank
      |> Map.update(Enum.sort(letter_bank, &>=/2), [unjumbled_sols], &[unjumbled_sols | &1])
    end)
    |> Enum.map(fn({letter_bank, unjumbled_sols})->
      letter_bank_string =
        letter_bank
        |> Enum.join(" ")
        |> Helper.cap(@letter_bank_lcap, @letter_bank_rcap)

      [pick_tree_timer_opts, solver_timer_opts] =
        unjumbled_sols
        |> build_timer_opts(letter_bank_string ,letter_bank)

      pick_tree_timer_opts
      |> Countdown.time_async
      |> report_and_record_picks(PickTree.dump_ids)

      group_size =
        unjumbled_sols
        |> length

      {letter_bank_string, solver_timer_opts, {unjumbled_sols, group_size}}
    end)
  end

  defp report_and_record_picks(time_elapsed, letter_bank, unjumbleds_tup = {_unjumbled_sols, group_size}, picks) do
    num_uniqs =
      picks
      |> Set.size

    next_total =
      @total_key_path
      |> get_in_agent
      |> + num_uniqs

    num_uniqs
    |> report(next_total, time_elapsed)

    if num_uniqs > 0 do
      @sols_key_path
      |> push_in_agent({ANSI.magenta <> letter_bank, unjumbleds_tup, num_uniqs, picks})

      @counts_key_path
      |> update_in_agent(fn(%{total: _last_total, max_group_size: max_group_size})->
        %{total: next_total, max_group_size: max(max_group_size, group_size)}
      end)
    end
  end

  defp report(num_uniqs, next_total, micro_sec) do
    sols_counts =
      [num_uniqs, next_total]
      |> Enum.reduce({"valid and unique: ", ["/", " (solved/total)"]}, fn(int, {lcap, [rcap | rest]})->
        int
        |> Integer.to_string
        |> Helper.cap(lcap, rcap)
        |> Helper.wrap_append(rest)
      end)
      |> elem(0)
    
    time_elapsed =
      micro_sec
      |> div(1000)
      |> Integer.to_string
      |> Helper.cap("time elapsed:     ", " ms")

    [sols_counts, time_elapsed]
    |> Enum.reduce(@report_indent, fn(line, report)->
      line
      |> Helper.cap(report, @report_indent)
    end)
    |> Helper.cap(ANSI.white, "\n")
    |> IO.puts
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp push_in_agent(key_path, el) do
    update_in_agent(key_path, &[el | &1])
  end

  defp get_in_agent(key_path) do
    __MODULE__
    |> Agent.get(Kernel, :get_in, [key_path])
  end


  defp put_in_agent(key_path, value) do
    __MODULE__
    |> Agent.update(Kernel, :put_in, [key_path, value])
  end

  defp update_in_agent(key_path, fun) do
    __MODULE__
    |> Agent.cast(Kernel, :update_in, [key_path, fun])
  end

  defp decrement_continues do
    __MODULE__
    |> Agent.get_and_update(Kernel, :get_and_update_in, [@rem_continues_key_path, &{&1, &1 - 1}])
  end

  defp build_timer_opts(unjumbled_sols, letter_bank_string, letter_bank) do
    complete_prompt = fn(inc_prompt)->
      unjumbled_sols
      |> Enum.join(@sol_spacer)
      |> Helper.cap(inc_prompt, "\n  " <> letter_bank_string)
    end

    complete_task = fn(inc_task)->
      inc_task
      |> Tuple.append([letter_bank])
    end

    @process_timer_opts
    |> Enum.map(fn(inc_timer_opts)->
      inc_timer_opts
      |> Keyword.update!(:prompt, complete_prompt)
      |> Keyword.update!(:task, complete_task)
    end)
  end
end

