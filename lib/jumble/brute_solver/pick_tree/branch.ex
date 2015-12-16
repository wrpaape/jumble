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

  def process(branch_pid, finished_letters) do
    branch_pid
    |> Agent.get(__MODULE__, :handle_letters, [finished_letters])
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def handle_letters({rem_letters, {id_index, id_length}, [next_id_tup = {_next_id_index, next_id_length} | rem_id_tups], acc_ids}, letters) do
    finished_id =
      letters
      |> Enum.join

    id_length
    |> ScowlDict.valid_id?(finished_id)
    |> if do
      next_acc_ids =
        [{id_index, finished_id} | acc_ids]

      next_rem_letters =
        rem_letters -- letters

      next_branch_pid =
        {next_rem_letters, next_id_tup, rem_id_tups, next_acc_ids}
        |> new_branch

      {rem_letters, next_id_length, next_branch_pid}
    else
      self
      |> PickTree.branch_done
    end
  end

  def handle_letters({_done, {id_index, id_length}, [], acc_ids}, letters) do
    last_finished_id =
      letters
      |> Enum.join

    id_length
    |> ScowlDict.valid_id?(last_finished_id)
    |> if do
      [{id_index, last_finished_id} | acc_ids]
      |> Enum.sort
      |> Keyword.values
      |> PickTree.put_ids
    end

    self
    |> PickTree.branch_done
  end
end