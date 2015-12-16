defmodule Jumble.BruteSolver.PickTree.Branch do
  alias Jumble.BruteSolver.PickTree
  alias Jumble.ScowlDict

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def new_branch(root_state) do
    {:ok, branch_pid} =
      Agent.start(fn ->
        root_state
      end)

    branch_pid
  end

  def next_branch_state(branch_pid, finished_letters) do
    branch_pid
    |> Agent.get(fn
      ({last_rem_letters, {id_index, id_length}, [next_id_tup = {_next_id_index, next_id_length} | rem_id_tups], last_acc_finished_ids}) ->
        finished_id =
          finished_letters
          |> Enum.join

        id_length
        |> ScowlDict.safe_valid_id?(finished_id)
        |> if do
          acc_fininished_ids =
            [{id_index, finished_id} | last_acc_finished_ids]

          rem_letters =
            last_rem_letters -- finished_letters

          next_branch_pid =
            {rem_letters, next_id_tup, rem_id_tups, acc_fininished_ids}
            |> new_branch

          {rem_letters, next_id_length, next_branch_pid}
        else
          PickTree.branch_done
        end

      ({_done, {last_id_index, last_id_length}, [], last_acc_finished_ids}) ->
        last_finished_id =
          finished_letters
          |> Enum.join

        last_id_length
        |> ScowlDict.safe_valid_id?(last_finished_id)
        |> if do
          [{last_id_index, last_finished_id} | last_acc_finished_ids]
          |> Enum.sort
          |> Keyword.values
          |> PickTree.put_ids
        end

        PickTree.branch_done
    end)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
end