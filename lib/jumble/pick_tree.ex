defmodule Jumble.PickTree do
  use GenServer

  alias Jumble.Picker
  alias Jumble.LengthDict
  alias Jumble.Helper
  alias Jumble.Stats

  def start_link(args = %{sol_info: sol_info}) do
    __MODULE__
    |> GenServer.start_link(sol_info, name: __MODULE__)
    
    args
  end

  def spawn_pickers(word_bank), do: GenServer.start_link(__MODULE__, {:spawn_pickers, word_bank})

  def process_raw(string_ids),  do: GenServer.cast(__MODULE__, {:process_raw, string_ids})

  def report_results,           do: GenServer.cast(__MODULE__, :report_results)


  

  def handle_cast({:process_raw, string_ids}, last_state = {acc_final_results, words_cache}) do
    words_cache
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
            |> Map.update!(:invalid_ids &Set.put(&1, invalid_id))
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

  def pre_process(words_cache = %{processed_raw: processed_raw, invalid_ids: invalid_ids}, string_ids) do
    processed_raw
    |> not_processed?(string_ids)
    |> if do
      :already_processed
    else
      next_words_cache =
        words_cache
        |> Map.update!(:processed_raw, &Set.put(&1, string_ids))

      invalid_ids
      |> any_invalid?(string_ids)
      |> if do: :includes_invalid_id, else: :proceed
      |> Helper.wrap_append(next_words_cache)
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



  # def process_raw_result(string_ids) do
  #   __MODULE__
  #   |> Agent.update(fn(last_final_results = {acc_final_results, words_cache = %{sol_lengths: sol_lengths, invalid_ids: invalid_ids, processed_raw: processed_raw}}) ->
  #     if Set.member?(processed_raw, string_ids) do
  #       last_final_results
  #     else
  #       words_cache =
  #         words_cache
  #         |> Map.update!(:processed_raw, &Set.put(&1, string_ids))

  #       result_is_invalid =
  #         string_ids
  #         |> Enum.any?(fn(string_id) ->
  #           invalid_ids
  #           |> Set.member?(string_id)
  #         end)
        
  #       if result_is_invalid do
  #         last_final_results
  #       else
  #         string_ids
  #         |> Enum.reduce_while({sol_lengths, []}, fn(string_id, {[string_length | rem_string_lengths], acc_valids}) ->
  #           valid_words = 
  #             string_length
  #             |> LengthDict.get(string_id)

  #           if valid_words do
  #             {:cont, {rem_string_lengths, [valid_words | acc_valids]}}
  #           else
  #             next_words_cache =
  #               words_cache
  #               |> Map.update!(:invalid_ids, &Set.put(&1, string_id))

  #             {:halt, next_words_cache}
  #           end
  #         end)
  #         |> case do
  #           {_last_pick, all_valid_words} ->
  #             next_acc_final_results =
  #               all_valid_words
  #               |> Stats.combinations
  #               # |> IO.inspect
  #               |> Enum.concat(acc_final_results)

  #             {next_acc_final_results, words_cache}
  #           next_words_cache ->
  #             {acc_final_results, next_words_cache}
  #         end
  #       end
  #     end
  #   end)
  # end

  def init(sol_info), do: {:ok, {[], sol_info}}

  def stash_root_state(root_state) do
    Agent.start_link(fn ->
      root_state
    end)
  end

  def spawn_pickers(intial_state = {acc_results, sol_info = %{pick_orders: pick_orders}})->
    pick_orders
    |> Enum.each(fn([{first_word_index, first_word_length} | rem_word_lengths]) ->
      {:ok, stash_pid} =
        {word_bank, first_word_index, rem_word_lengths, []}
        |> stash_root_state

      Picker
      |> spawn(:start_next_word, [{word_bank, first_word_length, stash_pid}])
    end)
    
    intial_state
    |> listen_for_first_result   
  end

  def next_root_state(stash_pid, finished_letters) do
    stash_pid
    |> Agent.get(fn
      ({last_rem_letters, word_index, [{next_word_index, next_word_length} | rem_word_lengths], last_acc_finished_words}) ->
        acc_fininished_words =
          [{word_index, Enum.join(finished_letters)} | last_acc_finished_words]

        rem_letters =
          last_rem_letters -- finished_letters

        {:ok, stash_pid} =
          {rem_letters, next_word_index, rem_word_lengths, acc_fininished_words}
          |> stash_root_state

        {rem_letters, next_word_length, stash_pid}


      ({_done, last_word_index, [], last_acc_finished_words}) ->
        string_ids =
          [{last_word_index, Enum.join(finished_letters)} | last_acc_finished_words]
          |> Enum.sort
          |> Keyword.values
          # |> process_raw_result
          __MODULE__
          |> send({:process_raw, string_ids})

        :done
    end)
  end
end