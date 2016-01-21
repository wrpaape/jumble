defmodule Jumble.BruteSolver.PickTree.Picker do
  alias Jumble.BruteSolver.PickTree.Branch

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_next_id({rem_letters, id_length, branch_pid}) do
    {initial_valid_picks, initial_downstream_picks} =
      rem_letters
      |> Enum.split(length(rem_letters) - (id_length - 1))

    __MODULE__
    |> spawn(:pick_letters, [{initial_valid_picks, initial_downstream_picks, []}, branch_pid])
  end

  def start_next_id(:ok), do: exit(:kill)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def pick_letters({last_valid_picks, [], acc_letters}, branch_pid) do
    last_valid_picks
    |> Enum.each(fn(last_pick) ->
      __MODULE__
      |> spawn(:start_next_id, [Branch.process(branch_pid, [last_pick | acc_letters])])
    end)
  end

  def pick_letters({valid_picks, [valid_next | rem_downstream_picks], acc_letters}, branch_pid) do
    valid_picks
    |> Enum.reduce(List.insert_at(valid_picks, -1, valid_next), fn(_pick, [pick | next_valid_picks]) ->
      __MODULE__
      |> spawn(:pick_letters, [{next_valid_picks, rem_downstream_picks, [pick | acc_letters]}, branch_pid])

      next_valid_picks
    end)
  end
end
