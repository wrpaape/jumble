defmodule Jumble.BruteSolver.Solver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Timer
  alias Jumble.Helper
  alias Jumble.Helper.Stats
  alias Jumble.BruteSolver
  alias Jumble.BruteSolver.Printer
  alias Jumble.BruteSolver.Reporter

  @rem_continues_key_path    ~w(sol_info rem_continues)a

  @report_color  ANSI.white
  # @report_indent Helper.pad(4)
  # @done_prompt @report_color
  #   |> Helper.cap(@report_indent, "done")

  @continue_prompt "\n\n    continue? (y/n)\n    "
    |> Helper.cap(ANSI.green, ANSI.blink_slow)
    |> Helper.cap(ANSI.black_background, "> " <> ANSI.blink_off)
    |> Helper.cap(ANSI.bright, ANSI.normal)

  @process_timer_opts [
      prompt: Helper.cap(ANSI.cyan, ANSI.black_background, "\n\nsolving batch "),
      task: {__MODULE__, :solve_next_batch},
      ticker_int: 17
    ]


##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def solve({sol_groups, num_batches}, dup_word_lists \\ HashSet.new, batch_index \\ 1) do
    sol_groups
    |> prepare_next_batch
    |> case do
      {[], []} -> 
        IO.puts "done"

      {next_batch, rem_sol_groups} ->
        prompt_suffix =
          batch_index
          |> build_prompt_suffix(num_batches)

        {time_elapsed, {uniq_word_lists, max_group_size, next_dup_word_lists}} =
          @process_timer_opts
          |> BruteSolver.append_prompt_suffix(prompt_suffix)
          |> BruteSolver.append_task_args([next_batch, dup_word_lists])
          |> Timer.time_sync

          time_elapsed
          |> Reporter.build_time_elapsed
          |> Printer.print_solutions(uniq_word_lists, max_group_size)
        
        request_continue

        solve({rem_sol_groups, num_batches}, next_dup_word_lists, batch_index + 1)
    end
  end


# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def request_continue do
    @continue_prompt
    |> IO.gets
    |> String.match?(~r/y/i)
    |> unless(do: System.halt(0))
  end
  
  def prepare_next_batch(sol_groups) do
    sol_groups
    |> Enum.reduce({[], []}, fn
      ({printer_tup, [batch_group | rem_batch_groups]}, {next_batch, rem_sol_groups})->

        [{printer_tup, batch_group} | next_batch]
        |> Helper.wrap_append([{printer_tup, rem_batch_groups} | rem_sol_groups])

      ({_printer_tup, []}, last_results_tup)->
        last_results_tup
    end)
  end

  def solve_next_batch(sol_batch, dup_word_lists) do
    sol_batch
    |> Enum.reduce({[], 0, dup_word_lists}, fn({printer_tup = {_, {_, group_size}}, {getters, picks}}, {uniq_sols, max_group_size, dup_word_lists})->
      picks
      |> Enum.flat_map_reduce(dup_word_lists, fn(pick, dup_word_lists)->
        getters
        |> Enum.reduce({[], pick}, fn(get_fun, {valid_words, [id | rem_ids]})->
          [get_fun.(id) | valid_words]
          |> Helper.wrap_append(rem_ids)
        end)
        |> elem(0)
        |> Stats.combinations
        |> filter_dups(dup_word_lists)
      end)
      |> case do
        {[], next_dup_word_lists} ->
          {uniq_sols, max_group_size, next_dup_word_lists}
        {next_uniq_sols, next_dup_word_lists} ->
          {[{printer_tup, length(next_uniq_sols), next_uniq_sols} | uniq_sols], max(max_group_size, group_size), next_dup_word_lists}
      end
    end)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp build_prompt_suffix(batch_index, num_batches) do
    [batch_index, num_batches]
    |> Enum.map_join("/", &Integer.to_string/1)
    |> Helper.cap("(", "):")
  end
  
  defp filter_dups(word_lists, dup_word_lists) do
    word_lists
    |> Enum.reduce({[], dup_word_lists}, fn(word_list, last_results_tup = {uniqs, dups})->
      dups
      |> Set.member?(word_list)
      |> if do
        last_results_tup
      else
        {[word_list | uniqs], Set.put(dups, word_list)}
      end
    end)
  end
end
