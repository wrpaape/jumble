defmodule Jumble.BruteSolver.PickTree.Branch do
  @branch_process_timeout 0

  alias Jumble.BruteSolver.PickTree

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def new_branch(root_state) do
    {:ok, branch_pid} =
      Agent.start_link(fn ->
        root_state
      end)

    branch_pid
  end

  def next_branch_state(branch_pid, finished_letters) do
    branch_pid
    |> Agent.get(fn
      ({last_rem_letters, word_index, [{next_word_index, next_word_length} | rem_word_lengths], last_acc_finished_words}) ->
        acc_fininished_words =
          [{word_index, Enum.join(finished_letters)} | last_acc_finished_words]

        rem_letters =
          last_rem_letters -- finished_letters

        next_branch_pid =
          {rem_letters, next_word_index, rem_word_lengths, acc_fininished_words}
          |> new_branch

        {rem_letters, next_word_length, next_branch_pid}


      ({_done, last_word_index, [], last_acc_finished_words}) ->
          [{last_word_index, Enum.join(finished_letters)} | last_acc_finished_words]
          |> Enum.sort
          |> Keyword.values
          |> PickTree.process_raw

          @branch_process_timeout
          |> :timer.apply_after(Agent, :stop, [branch_pid])

        :done
    end)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
end