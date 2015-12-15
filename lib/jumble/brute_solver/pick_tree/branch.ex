defmodule Jumble.BruteSolver.PickTree.Branch do
  @branch_process_timeout 1000

  alias Jumble.BruteSolver.PickTree
  alias Jumble.ScowlDict

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def new_branch(root_state) do
    {:ok, branch_pid} =
      Agent.start_link(fn ->
        root_state
      end)

    branch_pid
  end

  def stop_branch(branch_pid) do
    @branch_process_timeout
    |> :timer.apply_after(Agent, :stop, [branch_pid])

    :done
  end

  def next_branch_state(branch_pid, finished_letters) do
    branch_pid
    |> Agent.get(fn
      ({last_rem_letters, {id_index, id_length}, [next_id_tup = {_next_id_index, next_id_length} | rem_id_tups], last_acc_finished_ids}) ->
        finished_id =
          finished_letters
          |> Enum.join


        if ScowlDict.safe_valid_id?(id_length, finished_id) do
          acc_fininished_ids =
            [{id_index, finished_id} | last_acc_finished_ids]

          rem_letters =
            last_rem_letters -- finished_letters

          next_branch_pid =
            {rem_letters, next_id_tup, rem_id_tups, acc_fininished_ids}
            |> new_branch

          {rem_letters, next_id_length, next_branch_pid}
        else
          branch_pid
          |> stop_branch
        end

      ({_done, {last_id_index, last_id_length}, [], last_acc_finished_ids}) ->
        last_finished_id =
          finished_letters
          |> Enum.join

        if ScowlDict.safe_valid_id?(last_id_length, last_finished_id) do
          [{last_id_index, last_finished_id} | last_acc_finished_ids]
          |> Enum.sort
          |> Keyword.values
          |> PickTree.put_ids
        end

        branch_pid
        |> stop_branch
    end)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
end