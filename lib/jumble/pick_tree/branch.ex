defmodule Jumble.PickTree.Branch do
  def new_branch(root_state) do
    __MODULE__
    |> Agent.start_link(fn(root_state)->
      root_state
    end)
  end


  def next_root_state(branch_pid, finished_letters) do
    branch_pid
    |> Agent.get(fn
      ({last_rem_letters, word_index, [{next_word_index, next_word_length} | rem_word_lengths], last_acc_finished_words}) ->
        acc_fininished_words =
          [{word_index, Enum.join(finished_letters)} | last_acc_finished_words]

        rem_letters =
          last_rem_letters -- finished_letters

        {:ok, branch_pid} =
          {rem_letters, next_word_index, rem_word_lengths, acc_fininished_words}
          |> new_branch

        {rem_letters, next_word_length, branch_pid}


      ({_done, last_word_index, [], last_acc_finished_words}) ->
        string_ids =
          [{last_word_index, Enum.join(finished_letters)} | last_acc_finished_words]
          |> Enum.sort
          |> Keyword.values
          |> PickTree.process_raw

        :done
    end)
  end
end