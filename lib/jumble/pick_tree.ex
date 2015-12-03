defmodule Jumble.PickTree do
  alias Jumble.Picker
  alias Jumble.LengthDict
  alias Jumble.Helper
  alias Jumble.Stats

  def start_link(args = %{sol_info: sol_info}) do
    __MODULE__
    |> Agent.start_link(:init_master_tree, [sol_info], name: __MODULE__)
    
    args
  end

  def report_results do
    __MODULE__
    |> Agent.cast(fn(final_state = {final_results, _sol_info})->
      final_results
      |> Enum.each(&IO.inspect/1)

      final_state
    end)  
  end

  # def reset_timer do

  # end

  def push_raw_result(final_words) do
    __MODULE__
    |> Agent.update(fn
      ({acc_raw_results, words_cache})->
      {[final_words | acc_raw_results], words_cache}
    end)
  end

  # def process_raw_result(raw_string_ids) do
  #   __MODULE__
  #   |> Agent.update(fn(last_final_results = {acc_final_results, words_cache = %{sol_lengths: sol_lengths, invalid_ids: invalid_ids}}) ->
  #     result_is_invalid =
  #       raw_string_ids
  #       # |> IO.inspect
  #       |> Enum.any?(fn(string_id) ->
  #         invalid_ids
  #         |> Set.member?(string_id)
  #       end)
      
  #     if result_is_invalid do
  #       last_final_results
  #     else
  #       raw_string_ids
  #       |> Enum.reduce_while({sol_lengths, []}, fn(string_id, {[string_length | rem_string_lengths], acc_valids}) ->
  #         valid_words = 
  #           # ordered_lengths
  #           # string_id
  #           # |> String.length
  #           # |> Map.get(word_index)
  #           string_length
  #           |> LengthDict.get(string_id)

  #         if valid_words do
  #           {:cont, {rem_string_lengths, [valid_words | acc_valids]}}
  #         else
  #           next_words_cache =
  #             words_cache
  #             |> Map.update!(:invalid_ids, &Set.put(&1, string_id))

  #           {:halt, next_words_cache}
  #         end
  #       end)
  #       |> case do
  #         {_last_pick, all_valid_words} ->
  #           next_acc_final_results =
  #             all_valid_words
  #             |> Stats.combinations
  #             |> IO.inspect
  #             |> Enum.concat(acc_final_results)

  #           {next_acc_final_results, words_cache}
  #         next_words_cache ->
  #           {acc_final_results, next_words_cache}
  #       end
  #     end
  #   end)
  # end

  def init_master_tree(sol_info), do: {[], sol_info}

  def spawn_pickers(word_bank) do
    __MODULE__
    |> Agent.cast(fn({acc_results, sol_info = %{pick_orders: pick_orders}})->
      pick_orders
      |> Enum.each(fn([{first_word_index, first_word_length} | rem_word_lengths]) ->
        {:ok, stash_pid} =
          {word_bank, first_word_index, rem_word_lengths, []}
          |> stash_root_state

        Picker
        |> spawn(:start_next_word, [{word_bank, first_word_length, stash_pid}])
      end)
      
      {acc_results, sol_info}      
    end)
  end

  # def push_final_result(final_result) do
  #   __MODULE__
  #   |> Agent.update(fn(acc_final_results)->
  #     [final_result | acc_final_results]
  #   end)
  # end

  # def process_results do
  #     __MODULE__
  #     |> Agent.get_and_update(fn(final_tree_state = {_raw_results, _words_cache})->
  #       {final_tree_state, []}
  #     end)
  #     |> extract_valids

  #   report_results
  # end

  #   # Jumble.CLI.main
  #   # :timer.sleep 500
  #   # Jumble.PickTree.process_results

  # def extract_valids({raw_results, %{lengths: lengths, invalid_ids: invalid_ids}) do
  #   processed_results
  #   |> Enum.scan(invalid_ids, fn(final_ids, invalid_ids)->
  #     definitely_invalid =
  #       final_ids
  #       |> Enum.any?(fn(string_id) ->
  #         Set.member?(invalid_ids, string_id)
  #       end)

  #     if not definitely_invalid do
  #       final_ids
  #       |> Enum.reduce_while({lengths, []}, fn(string_id, {[length_word | next_word_lengths], acc_valids}) ->
  #         valid_words = 
  #           length_word

  #         if valid_words do
  #           {:cont, {next_word_lengths, [valid_words | acc_valids]}}
  #         else
  #           {:halt, Set.put(invalid_ids, string_id)}
  #         end
  #       end)
  #       |> case do
  #         {[], all_valid_words} ->
  #           next_acc_results =
  #             all_valid_words
  #             |> Stats.combinations
  #             |> Enum.each(&push_final_result/1)

  #         next_invalid_ids ->
  #           invalid_ids = next_invalid_ids
  #       end
  #     end

  #     invalid_ids
  #   end)
  # end


  def stash_root_state(root_state) do
    Agent.start_link(fn ->
      root_state
    end)
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
        words =
          [{last_word_index, Enum.join(finished_letters)} | last_acc_finished_words]
          |> Enum.sort
          |> Keyword.values
          |> push_raw_result

        :done
    end)
  end
end