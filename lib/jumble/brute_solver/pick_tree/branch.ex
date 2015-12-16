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
    |> Agent.get(__MODULE__, :handle_letters, [finished_letters])
    |> Agent.get(fn
      () ->
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
          branch_pid
          |> PickTree.branch_done
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

        branch_pid
        |> PickTree.branch_done
    end)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def handle_letters({rem_letters, {id_index, valid_id?}, [{next_id_index, next_id_length, next_valid_id?} | rem_id_tups], acc_ids}, letters) do
    finished_id =
      finished_letters
      |> Enum.join

    if valid_id?.(finished_id) do
      next_acc_ids =
        [{id_index, finished_id} | acc_ids]

      next_rem_letters =
        rem_letters -- finished_letters

      next_branch_pid =
        {next_rem_letters, {next_id_index, next_valid_id?}, rem_id_tups, next_acc_ids}
        |> new_branch

      {rem_letters, next_id_length, next_branch_pid}
    else
      self
      |> PickTree.branch_done
    end
  end

  def handle_letters({_done, {id_index, valid_id?}, [], acc_ids}, letters) do
    last_finished_id =
      finished_letters
      |> Enum.join

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