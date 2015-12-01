defmodule Jumble.PickTree do
  alias Jumble.Picker

  def start_link(total_word_bank, all_word_lengths) do
    __MODULE__
    |> Agent.start_link(:init_master_tree, [total_word_bank, all_word_lengths], name: __MODULE__)
  end

  def report_result(result) do
    __MODULE__
    |> Agent.update(fn(acc_results) -> [result | acc_results] end)
  end

  def init_master_tree(word_bank, [first_word_length | rem_word_lengths]) do
    IO.puts "initializing pick tree..."

    {:ok, stash_pid} =
      {word_bank, rem_word_lengths, []}
      |> stash_root_state

    Picker
    |> spawn(:start_next_word, [word_bank, first_word_length, stash_pid])

    []
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
        acc_finished_letters =
          [finished_letters | last_acc_finished_letters]

        rem_letters =
          last_rem_letters -- finished_letters

        {:ok, stash_pid} =
          {rem_letters, rem_word_lengths, acc_finished_letters}
          |> stash_root_state

        {rem_letters, next_word_length, stash_pid}

      ({_done, [], last_acc_finished_letters}) ->
        [finished_letters | last_acc_finished_letters]
        |> Enum.map(fn(disjoint_letters) ->
          disjoint_letters
          |> List.foldr("", fn(letter, word) ->
            word <> letter
          end)
        end)
    end)
  end
end