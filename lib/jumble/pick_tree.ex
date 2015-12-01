defmodule Jumble.PickTree do
  alias Jumble.Picker
  alias Jumble.LengthDict
  alias Jumble.Helper

  def start_link(total_word_bank, all_word_lengths) do
    LengthDict
    |> Agent.start_link(:build_dict, [[3, 4]], name: LengthDict)

    __MODULE__
    |> Agent.start_link(:init_master_tree, [total_word_bank, all_word_lengths], name: __MODULE__)
  end

  def process_result(final_words) do
    __MODULE__
    |> Agent.update(fn(last_results = {acc_results, words_cache = %{lengths: lengths, invalid_ids: invalid_ids}}) ->
      result_is_invalid =
        final_words
        |> Enum.any?(fn(word) ->
          invalid_ids
          |> Set.member?(word)
        end)
      
      if result_is_invalid do
        last_results
      else
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
              |> Enum.concat(acc_results)
              # |> IO.inspect

            {next_acc_results, words_cache}
          next_words_cache ->
            {acc_results, next_words_cache}
        end
      end
    end)
  end

  def init_master_tree(word_bank, ordered_word_lengths) do
    IO.puts "initializing picker..."

    sorted_word_bank =
      word_bank
      |> Enum.sort(&(&1 > &2))

    [first_word_length | rem_word_lengths] =
      ordered_word_lengths
      |> Enum.reverse


    {:ok, stash_pid} =
      {sorted_word_bank, rem_word_lengths, []}
      |> stash_root_state

    Picker
    |> spawn(:start_next_word, [word_bank, first_word_length, stash_pid])

    words_cache =
      %{lengths: ordered_word_lengths, invalid_ids: HashSet.new}

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