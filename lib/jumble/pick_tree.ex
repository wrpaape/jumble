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
    |> Agent.get(fn(final_results)->
      final_results
      |> Enum.each(&IO.inspect/1)
    end)  
  end

  def push_raw_result(final_words) do
    __MODULE__
    |> Agent.update(fn({acc_raw_results, words_cache})->
      {[final_words | acc_raw_results], words_cache}
    end)
  end

  def push_final_result(final_result) do
    __MODULE__
    |> Agent.update(fn(acc_final_results)->
      [final_result | acc_final_results]
    end)
  end

  def process_results do
    {raw_results, num_words, words_cache} =
      __MODULE__
      |> Agent.get_and_update(fn({acc_raw_results, words_cache = %{num_words: num_words}})->
        {{acc_raw_results, num_words, words_cache}, []}
      end)

    raw_results
    # |> Enum.reduce(List.duplicate(HashSet.new, num_words), fn(words, uniq_cols)->
    #   uniq_cols
    #   |> Enum.map_reduce(words, fn(uniq_col, [col_word | rem_words])->
    #     {Set.put(uniq_col, col_word), rem_words}
    #   end)
    #   |> elem(0)
    # end)
    # |> Enum.map(&Enum.to_list/1)
    # |> Helper.combinations
    |> filter_results(words_cache)
  end

    # Jumble.CLI.main
    # :timer.sleep 500
    # Jumble.PickTree.process_results

  def filter_results(processed_results, %{lengths: lengths, invalid_ids: invalid_ids}) do
    processed_results
    |> Enum.scan(invalid_ids, fn(final_ids, invalid_ids)->
      definitely_invalid =
        final_ids
        |> Enum.any?(fn(string_id) ->
          Set.member?(invalid_ids, string_id)
        end)

      if not definitely_invalid do
        final_ids
        # |> Enum.reduce({lengths, []}, fn(string_id, {[length_word | next_word_lengths], acc_valids}) ->
        #   valid_words = 
        #     length_word
        #     |> LengthDict.get(string_id)

        #   {next_word_lengths, [valid_words | acc_valids]}
        # end)
        # |> elem(1)
        # |> Helper.combinations
        # |> Enum.each(&push_final_result/1)
        |> Enum.reduce_while({lengths, []}, fn(string_id, {[length_word | next_word_lengths], acc_valids}) ->
          valid_words = 
            length_word
            |> LengthDict.get(string_id)
            |> IO.inspect

          if valid_words do
            {:cont, {next_word_lengths, [valid_words | acc_valids]}}
          else
            IO.puts(inspect(string_id) <> " failed tossing:")
            IO.inspect valid_words
            {:halt, Set.put(invalid_ids, string_id)}
          end
        end)
        |> case do
          {[], all_valid_words} ->
            next_acc_results =
              all_valid_words
              |> Helper.combinations
              |> Enum.each(&push_final_result/1)

          next_invalid_ids ->
            invalid_ids = next_invalid_ids
        end
      end

      invalid_ids
    end)
    
    report_results
  end

  def init_master_tree(word_bank, {ordered_word_lengths, uniq_word_lengths}) do
    sorted_word_bank =
      word_bank
      |> Enum.sort(&>=/2)

    # num_words =
    #   ordered_word_lengths
    #   |> length

    [first_word_length | rem_word_lengths] =
      ordered_word_lengths
      |> Enum.reverse

    {:ok, stash_pid} =
      {sorted_word_bank, rem_word_lengths, []}
      |> stash_root_state

    Picker
    |> spawn(:start_next_word, [word_bank, first_word_length, stash_pid])

    words_cache =
      %{num_words: num_words, lengths: ordered_word_lengths, uniq_lengths: uniq_word_lengths, invalid_ids: HashSet.new}

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