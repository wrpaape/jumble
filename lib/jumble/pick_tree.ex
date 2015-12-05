defmodule Jumble.PickTree do
  @countdown_opts [
    timeout: 500
    ticker_int: 1000
  ]
  |> Keyword.put(:ticker_int, 1000)

  use GenServer

  alias Jumble.PickTree.Branch
  alias Jumble.PickTree.Picker
  alias Jumble.Timer
  alias Jumble.LengthDict
  alias Jumble.Helper
  alias Jumble.Stats

  def start_link(args = %{sol_info: sol_info}) do
    __MODULE__
    |> GenServer.start_link(sol_info, name: __MODULE__)

    args
  end

  def pick_valid_sols(word_bank), do: GenServer.cast(__MODULE__, {:pick_valid_sols, word_bank})

  def process_raw(string_ids),    do: GenServer.cast(__MODULE__, {:process_raw, string_ids})

  def get_results,                do: GenServer.call(__MODULE__, :get_results)

  # def report_results,          do: GenServer.cast(__MODULE__, :report_results)


  # def process(word_bank) do
  #   countdown =
  #     Timer
  #     |> Task.await(:start_countdown, [@countdown_opts, &get_results/0])

  #   pick_valid_sols

  #   countdown
  #   |> Task.await

  #   get_results
  # end

  def init(sol_info), do: {:ok, {[], sol_info}}

  def handle_cast({:pick_valid_sols, word_bank}, state = {acc_results, sol_info = %{pick_orders: pick_orders}}) do
    pick_orders
    |> Enum.each(fn([{first_word_index, first_word_length} | rem_word_lengths]) ->
      branch_pid =
        {word_bank, first_word_index, rem_word_lengths, []}
        |> Branch.new_branch

      Picker
      |> spawn(:start_next_word, [{word_bank, first_word_length, branch_pid}])
    end)
  end

  def handle_cast({:process_raw, string_ids}, last_state = {acc_final_results, last_words_cache}) do
    Timer.reset_countdown

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

  # def handle_cast(:report_results, final_state = {final_results, words_cache}) do
  #   final_results
  #   # |> Enum.each(&IO.inspect/1)
  #   |> length
  #   |> IO.inspect

  #   {:noreply, final_state}
  # end

  def handle_call(:get_results, _from, final_state = {final_results, _words_cache}) do

    
    {:reply, final_results, final_state}
  end



  def not_processed?(processed_raw, string_ids) do
    processed_raw
    |> Set.member?(string_ids)
  end

  def any_invalid?(invalid_ids, string_ids) do
    string_ids
    |> Enum.any?(fn(string_id) ->
      invalid_ids
      |> Set.member?(string_id)
    end)
  end

  def pre_process(last_words_cache = %{processed_raw: processed_raw, invalid_ids: invalid_ids}, string_ids) do
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

  def extract_valid_words(%{sol_lengths: sol_lengths}, string_ids) do
    string_ids
    |> Enum.reduce_while({sol_lengths, []}, fn(string_id, {[string_length | rem_string_lengths], acc_valids}) ->
      valid_words = 
        string_length
        |> LengthDict.get(string_id)

      if valid_words do
        {:cont, {rem_string_lengths, [valid_words | acc_valids]}}
      else
        {:halt, {:found_invalid_id, string_id}}
      end
    end)
  end
end