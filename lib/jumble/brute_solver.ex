defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Printer
  alias Jumble.Countdown

  @prompt_spacer ANSI.blue  <> "solving for:\n\n "
  @sol_spacer    ANSI.white <> " or\n "
  @report_indent "\n" <> Helper.pad(4)
  @letter_bank_lcap         "{ " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"
  @counts_key_path ~w(sol_info brute counts)a
  @total_key_path  ~w(sol_info brute counts total)a
  @sols_key_path   ~w(sol_info brute sols)a
  @show_num_results 10
  @timer_opts [
    task: {PickTree, :pick_valid_sols},
    timeout: 50,
    ticker_int: 17
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

    args
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    [:jumble_info, :jumble_maps, jumble, :unjumbleds]
    |> push_in_agent({unjumbled, key_letters})
  end

  def process do
    __MODULE__
    |> Agent.get(fn(%{jumble_info: %{jumble_maps: jumble_maps}})->
      jumble_maps
    end)
    |> brute_solve
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp brute_solve(jumble_maps) do
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
    |> Enum.reduce(0, fn({letter_bank, sols}, sol_groups)->
      letter_bank_string =
        letter_bank
        |> Enum.join(" ")
        |> Helper.cap(@letter_bank_lcap, @letter_bank_rcap)

      sols
      |> Enum.join(@sol_spacer)
      |> Helper.cap(@prompt_spacer, "\n  " <> letter_bank_string)
      |> IO.puts

      letter_bank
      |> update_timer_opts
      |> Countdown.time_async
      |> report_and_record(letter_bank_string, sols, PickTree.dump_results)

      sol_groups + 1
    end)
    |> Printer.print_solutions(get_in_agent(@counts_key_path), get_in_agent(@sols_key_path))
  end

  defp report_and_record(time_elapsed, letter_bank, unjumbled_sols, results) do
    num_uniqs =
      results
      |> length

    next_total =
      @total_key_path
      |> get_in_agent
      |> + num_uniqs

    num_uniqs
    |> report(next_total, time_elapsed)
    
    @sols_key_path
    |> push_in_agent({letter_bank, unjumbled_sols, results})

    @counts_key_path
    |> update_in_agent(fn(%{total: _last_total, indivs: indivs})->
      %{total: next_total, indivs: [num_uniqs | indivs]}
    end)
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

  defp update_in_agent(key_path, fun) do
    __MODULE__
    |> Agent.cast(Kernel, :update_in, [key_path, fun])
  end

  defp update_timer_opts(word_bank) do
    @timer_opts
    |> Keyword.update!(:task, &Tuple.append(&1, [word_bank]))
  end
end

