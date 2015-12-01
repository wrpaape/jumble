defmodule PickTree do
  def start_link(root_state) do
    __MODULE__
    |> Agent.start_link(:new_tree, [root_state], name: __MODULE__)
  end

    def stash_state(root_state) do
      Agent.start_link(fn ->
        root_state
      end
    end

  def next_root_state(stash_pid, finished_letters) do
    stash_pid
    |> Agent.get(fn
      ({[], [], acc_finished_letters}) ->
        [finished_letters | acc_finished_letters]
        |> Enum.map(&Enum.join/1)
      ({rem_letters, rem_word_lengths, acc_finished_letters}) ->

        {rem_letters -- finished_letters, rem_word_lengths, [finished_letters | acc_finished_letters]}
    end
  end
end