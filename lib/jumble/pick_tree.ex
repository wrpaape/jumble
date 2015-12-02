defmodule Jumble.PickTree do
  alias Jumble.Picker
  alias Jumble.LengthDict
  alias Jumble.Helper

  def start_link(total_word_bank, all_word_lengths) do
    __MODULE__
    |> Agent.start_link(:init_master_tree, [total_word_bank, all_word_lengths], name: __MODULE__)
  end

  def push_raw_result(final_words) do
    __MODULE__
    |> Agent.update(fn({acc_raw_results, words_cache})->
      {[final_words | acc_raw_results], words_cache}
    end)
  end

  def push_final_result(final_result) do
    IO.inspect(final_result)

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
    |> Enum.reduce(List.duplicate(HashSet.new, num_words), fn(words, uniq_cols)->
      uniq_cols
      |> Enum.map_reduce(words, fn(uniq_col, [col_word | rem_words])->
        {Set.put(uniq_col, col_word), rem_words}
      end)
      |> elem(0)
    end)
    |> Enum.map(&Enum.to_list/1)
    |> Helper.combinations
    |> filter_results(words_cache)
  end
  def filter_results(processed_results, %{lengths: lengths, invalid_ids: invalid_ids}) do
    processed_results
    |> Enum.scan(invalid_ids, fn(result, invalid_ids)->
      definitely_invalid =
        final_words
        |> Enum.any?(fn(word) ->
          Set.member?(invalid_ids, word)
        end)

      if not definitely_invalid do
        final_words
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
            next_acc_results =
              all_valid_words
              |> Helper.combinations
              |> IO.inspect
              |> Enum.concat(acc_results)

            {next_acc_results, words_cache}
          next_words_cache ->
            {acc_results, next_words_cache}
        end
      end


      invalid_ids
    end)
  end

  def init_master_tree(word_bank, ordered_word_lengths) do
    sorted_word_bank =
      word_bank
      |> Enum.sort(&>=/2)

    num_words =
      ordered_word_lengths
      |> length

    [first_word_length | rem_word_lengths] =
      ordered_word_lengths
      |> Enum.reverse

    {:ok, stash_pid} =
      {sorted_word_bank, rem_word_lengths, []}
      |> stash_root_state

    Picker
    |> spawn(:start_next_word, [word_bank, first_word_length, stash_pid])

    words_cache =
      %{num_words: num_words, lengths: ordered_word_lengths, invalid_ids: HashSet.new}

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