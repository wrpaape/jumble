defmodule Jumble.BruteSolver.PickTree.Branch do
  alias Jumble.BruteSolver.PickTree

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
    |> Agent.get(__MODULE__, :handle_letters, [finished_letters, Enum.join(finished_letters)])
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def handle_letters({last_rem_letters, {id_index, valid_id?}, [{next_id_index, next_id_length, next_valid_id?} | rem_id_tups], acc_ids}, letters, finished_id) do
    if valid_id?.(finished_id) do
      next_acc_ids =
        [{id_index, finished_id} | acc_ids]

      next_rem_letters =
        last_rem_letters -- letters

      next_branch_pid =
        {next_rem_letters, {next_id_index, next_valid_id?}, rem_id_tups, next_acc_ids}
        |> new_branch

      {next_rem_letters, next_id_length, next_branch_pid}
    else
      self
      |> PickTree.branch_done
    end
  end

  def handle_letters({_done, {id_index, valid_id?}, [], acc_ids}, _letters, last_finished_id) do
    if valid_id?.(last_finished_id) do
      [{id_index, last_finished_id} | acc_ids]
      |> Enum.sort
      |> Keyword.values
      |> PickTree.put_ids
    end

    self
    |> PickTree.branch_done
  end
end
