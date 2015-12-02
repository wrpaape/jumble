defmodule Jumble.PickTree do
  alias Jumble.Picker
  alias Jumble.LengthDict
  alias Jumble.Helper

  def start_link(total_word_bank, length_info) do
    __MODULE__
    |> Agent.start_link(:init_master_tree, [total_word_bank, length_info], name: __MODULE__)
  end

  def report_results do
    __MODULE__
    |> Agent.get(fn({final_results, _})->
      final_results
      |> Enum.each(&IO.inspect/1)

      final_results
    end)  
  end

  # def push_raw_result(final_words) do
  #   __MODULE__
  #   |> Agent.update(fn({acc_raw_results, words_cache})->
  #     {[final_words | acc_raw_results], words_cache}
  #   end)
  # end

  def process_raw_result(raw_string_ids) do
    __MODULE__
    |> Agent.update(fn(last_final_results = {acc_final_results, words_cache = %{lengths: lengths, invalid_ids: invalid_ids}}) ->
      result_is_invalid =
        raw_string_ids
        |> Enum.any?(fn(id) ->
          invalid_ids
          |> Set.member?(id)
        end)
      
      if result_is_invalid do
        last_final_results
      else
        raw_string_ids
        |> Enum.reduce_while({lengths, []}, fn(string_id, {[length_word | next_word_lengths], acc_valids}) ->
          valid_words = 
            length_word
            |> LengthDict.get(string_id)

          if valid_words do
            {:cont, {next_word_lengths, [valid_words | acc_valids]}}
          else
            next_words_cache =
              words_cache
              |> Map.update!(:invalid_ids, &Set.put(&1, string_id))

            {:halt, next_words_cache}
          end
        end)
        |> case do
          {[], all_valid_words} ->
            next_acc_final_results =
              all_valid_words
              |> Helper.combinations
              # |> IO.inspect
              |> Enum.concat(acc_final_results)

            {next_acc_final_results, words_cache}
          next_words_cache ->
            {acc_final_results, next_words_cache}
        end
      end
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
  #             |> Helper.combinations
  #             |> Enum.each(&push_final_result/1)

  #         next_invalid_ids ->
  #           invalid_ids = next_invalid_ids
  #       end
  #     end

  #     invalid_ids
  #   end)
  # end

  def init_master_tree(word_bank, {ordered_word_lengths, uniq_word_lengths}) do
    sorted_word_bank =
      word_bank
      |> Enum.sort(&>=/2)

    [first_word_length | rem_word_lengths] =
      ordered_word_lengths
      |> Enum.reverse



    {:ok, stash_pid} =
      {sorted_word_bank, rem_word_lengths, []}
      |> stash_root_state

    Picker
    |> spawn(:start_next_word, [word_bank, first_word_length, stash_pid])

    words_cache =
      %{lengths: ordered_word_lengths, uniq_lengths: uniq_word_lengths, invalid_ids: HashSet.new}

    {[], words_cache}
  end

  def stash_root_state(root_state) do
    Agent.start_link(fn ->
      root_state
    end)
  end

  def next_root_state(stash_pid, finished_letters) do
    stash_pid
    |> Agent.get(fn
      ({last_rem_letters, [next_word_length | rem_word_lengths], last_acc_finished_letters}) ->
        acc_fininished_letters =
          [finished_letters | last_acc_finished_letters]

        rem_letters =
          last_rem_letters -- finished_letters

        {:ok, stash_pid} =
          {rem_letters, rem_word_lengths, acc_fininished_letters}
          |> stash_root_state

        {rem_letters, next_word_length, stash_pid}


      ({_done, [], last_acc_finished_letters}) ->
        words =
          [finished_letters | last_acc_finished_letters]
          |> Enum.map(&Enum.join/1)

        {:done, words}
    end)
  end
end