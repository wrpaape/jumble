defmodule Jumble.BruteSolver.Solver do
  use GenServer

  alias IO.ANSI
  alias Jumble.Countdown
  alias Jumble.ScowlDict
  alias Jumble.Helper
  alias Jumble.Helper.Stats

  @num_scowl_dicts Application.get_env(:jumble, :num_scowl_dicts)
  @rem_continues_key_path    ~w(sol_info rem_continues)a

  @continue_prompt "\n\n  continue? (y/n)\n  "
    |> Helper.cap(ANSI.white, ANSI.blink_slow)
    |> Helper.cap(ANSI.black_background, "> " <> ANSI.blink_off)


  def process_raw(string_ids),      do: GenServer.cast(__MODULE__, {:process_raw, string_ids})

  def handle_cast({:process_raw, string_ids}, last_state = {acc_final_results, last_words_cache}) do
    Countdown.reset_countdown

    last_words_cache
    |> pre_process(string_ids)
    |> case do
      :already_processed ->
        last_state

      {:includes_invalid_id, words_cache} ->
        {acc_final_results, words_cache}

      {:proceed, words_cache} ->
        words_cache
        |> extract_valid_words(string_ids)
        |> case do
          {:found_invalid_id, invalid_id} ->
            words_cache
            |> Map.update!(:invalid_ids, &Set.put(&1, invalid_id))
            |> Helper.wrap_prepend(acc_final_results)

          {[], all_valid_words} ->
            all_valid_words
            |> Stats.combinations
            |> Enum.concat(acc_final_results)
            |> Helper.wrap_append(words_cache)
        end
    end
    |> Helper.wrap_prepend(:noreply)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp not_processed?(processed_raw, string_ids) do
    processed_raw
    |> Set.member?(string_ids)
  end

  defp any_invalid?(invalid_ids, string_ids) do
    string_ids
    |> Enum.any?(fn(string_id) ->
      invalid_ids
      |> Set.member?(string_id)
    end)
  end

  defp pre_process(last_words_cache = %{processed_raw: processed_raw, invalid_ids: invalid_ids}, string_ids) do
    processed_raw
    |> not_processed?(string_ids)
    |> if do
      :already_processed
    else
      words_cache =
        last_words_cache
        |> Map.update!(:processed_raw, &Set.put(&1, string_ids))

      invalid_ids
      |> any_invalid?(string_ids)
      |> if do
       :includes_invalid_id
      else
        :proceed
      end |> Helper.wrap_append(words_cache)
    end
  end

  defp extract_valid_words(%{sol_lengths: sol_lengths}, string_ids) do
    string_ids
    |> Enum.reduce_while({sol_lengths, []}, fn(string_id, {[string_length | rem_string_lengths], acc_valids}) ->
      valid_words = 
        string_length
        |> ScowlDict.limited_get(string_id)

      if valid_words do
        {:cont, {rem_string_lengths, [valid_words | acc_valids]}}
      else
        {:halt, {:found_invalid_id, string_id}}
      end
    end)
  end
end

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
  #       |> Countdown.time_async
  #       |> report_and_record(letter_bank_string, unjumbleds_tup, PickTree.dump_ids)
  #     end)

  #     @sols_key_path
  #     |> get_in_agent
  #     |> Printer.print_solutions(get_in_agent(@max_group_size_key_path))

  #     request_continue
  #   end
  # end