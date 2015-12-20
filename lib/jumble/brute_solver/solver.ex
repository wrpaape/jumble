defmodule Jumble.BruteSolver.Solver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Timer
  alias Jumble.ScowlDict
  alias Jumble.Helper
  alias Jumble.Helper.Stats
  alias Jumble.BruteSolver
  alias Jumble.BruteSolver.Printer
  alias Jumble.BruteSolver.Reporter

  @num_scowl_dicts Application.get_env(:jumble, :num_scowl_dicts)
  @rem_continues_key_path    ~w(sol_info rem_continues)a

  @report_color  ANSI.white
  # @report_indent Helper.pad(4)
  # @done_prompt @report_color
  #   |> Helper.cap(@report_indent, "done")

  @continue_prompt "\n\n  continue? (y/n)\n  "
    |> Helper.cap(@report_color, ANSI.blink_slow)
    |> Helper.cap(ANSI.black_background, "> " <> ANSI.blink_off)

  @process_timer_opts [
      prompt: Helper.cap(ANSI.blue, ANSI.black_background, "\n\nsolving batch "),
      task: {__MODULE__, :solve_next_batch},
      ticker_int: 17
    ]


##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def solve(sol_groups, dup_word_lists \\ HashSet.new, batch_index \\ 1) do
    sol_groups
    |> prepare_next_batch
    |> case do
      {[], []} -> 
        IO.puts "done"

      {next_batch, rem_sol_groups} ->
        {time_elapsed, {uniq_word_lists, max_group_size, next_dup_word_lists}} =
          @process_timer_opts
          |> BruteSolver.append_prompt_suffix(Integer.to_string(batch_index) <> ":")
          |> BruteSolver.append_task_args([next_batch, dup_word_lists])
          |> Timer.time_sync

          time_elapsed
          |> Reporter.build_time_elapsed
          |> Printer.print_solutions(uniq_word_lists, max_group_size)
        
        :timer.sleep 3000

        solve(rem_sol_groups, next_dup_word_lists, batch_index + 1)
    end
  end


# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
  
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

#   def process_raw(string_ids),      do: GenServer.cast(__MODULE__, {:process_raw, string_ids})

#   def handle_cast({:process_raw, string_ids}, last_state = {acc_final_results, last_words_cache}) do
#     Timer.reset_countdown

#     last_words_cache
#     |> pre_process(string_ids)
#     |> case do
#       :already_processed ->
#         last_state

#       {:includes_invalid_id, words_cache} ->
#         {acc_final_results, words_cache}

#       {:proceed, words_cache} ->
#         words_cache
#         |> extract_valid_words(string_ids)
#         |> case do
#           {:found_invalid_id, invalid_id} ->
#             words_cache
#             |> Map.update!(:invalid_ids, &Set.put(&1, invalid_id))
#             |> Helper.wrap_prepend(acc_final_results)

#           {[], all_valid_words} ->
#             all_valid_words
#             |> Stats.combinations
#             |> Enum.concat(acc_final_results)
#             |> Helper.wrap_append(words_cache)
#         end
#     end
#     |> Helper.wrap_prepend(:noreply)
#   end

# ####################################### helpers ########################################
# # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

#   defp not_processed?(processed_raw, string_ids) do
#     processed_raw
#     |> Set.member?(string_ids)
#   end

#   defp any_invalid?(invalid_ids, string_ids) do
#     string_ids
#     |> Enum.any?(fn(string_id) ->
#       invalid_ids
#       |> Set.member?(string_id)
#     end)
#   end

#   defp pre_process(last_words_cache = %{processed_raw: processed_raw, invalid_ids: invalid_ids}, string_ids) do
#     processed_raw
#     |> not_processed?(string_ids)
#     |> if do
#       :already_processed
#     else
#       words_cache =
#         last_words_cache
#         |> Map.update!(:processed_raw, &Set.put(&1, string_ids))

#       invalid_ids
#       |> any_invalid?(string_ids)
#       |> if do
#        :includes_invalid_id
#       else
#         :proceed
#       end |> Helper.wrap_append(words_cache)
#     end
#   end

#   defp extract_valid_words(%{sol_lengths: sol_lengths}, string_ids) do
#     string_ids
#     |> Enum.reduce_while({sol_lengths, []}, fn(string_id, {[string_length | rem_string_lengths], acc_valids}) ->
#       valid_words = 
#         string_length
#         |> ScowlDict.limited_get(string_id)

#       if valid_words do
#         {:cont, {rem_string_lengths, [valid_words | acc_valids]}}
#       else
#         {:halt, {:found_invalid_id, string_id}}
#       end
#     end)
#   end
# end

  # def request_continue do
  #   @continue_prompt
  #   |> IO.gets
  #   |> String.match?(~r/y/i)
  #   |> if do
  #     ScowlDict.update_limit

  #     solve_next
  #   end
  # end

  # defp brute_solve(letter_bank_info) do
  #   @letter_bank_info_key_path
  #   |> put_in_agent(letter_bank_info)

  #   solve_next
  # end

  # defp solve_next do
  #   rem_continues =
  #     @rem_continues_key_path
  #     |> get_and_inc_in_agent(-1)

  #   if rem_continues > 0 do
  #     @letter_bank_info_key_path
  #     |> get_in_agent
  #     |> Enum.each(fn({letter_bank_string, timer_opts, unjumbleds_tup})->
  #       timer_opts
  #       |> Timer.time_async
  #       |> report_and_record(letter_bank_string, unjumbleds_tup, PickTree.dump_ids)
  #     end)

  #     @sols_key_path
  #     |> get_in_agent
  #     |> Printer.print_solutions(get_in_agent(@max_group_size_key_path))

  #     request_continue
  #   end
  # end