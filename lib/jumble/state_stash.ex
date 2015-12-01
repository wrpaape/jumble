defmodule StateStash do
  def start_link(root_state) do
    fn ->
      root_state
    end
    |> Agent.start_link(name: __MODULE__)
  end

  def next_root_state(finished_word) do
    Agent.get(fn({rem_letters, rem_word_lengths, acc_words}))

  end
end