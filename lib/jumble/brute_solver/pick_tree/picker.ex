defmodule Jumble.BruteSolver.PickTree.Picker do
  alias Jumble.BruteSolver.PickTree.Branch

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_next_word({rem_letters, word_length, branch_pid}) do
    {initial_valid_picks, initial_downstream_picks} =
      rem_letters
      |> Enum.split(1 - word_length)

    {initial_valid_picks, initial_downstream_picks, []}
    |> pick_letters(branch_pid)
  end

  def start_next_word(:done), do: :nothing

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp pick_letters({last_valid_picks, [], acc_letters}, branch_pid) do
    last_valid_picks
    |> Enum.each(fn(last_pick) ->
      branch_pid
      |> Branch.next_branch_state([last_pick | acc_letters])
      |> start_next_word
    end)
  end

  defp pick_letters({valid_picks, [valid_next | rem_downstream_picks], acc_letters}, branch_pid) do
    valid_picks
    |> map_picks_with_next_valid_picks(valid_next)
    |> Enum.each(fn({pick, next_valid_picks}) ->
      {next_valid_picks, rem_downstream_picks, [pick | acc_letters]}
      |> pick_letters(branch_pid)
    end)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp map_picks_with_next_valid_picks(valid_picks, valid_next) do
    intial_picks_acc =
      valid_picks
      |> List.insert_at(-1, valid_next)
 
    valid_picks
    |> Enum.scan({nil, intial_picks_acc}, fn(pick, {_last_pick, last_pick_acc}) ->

      {pick, tl(last_pick_acc)}
    end)
  end
end
