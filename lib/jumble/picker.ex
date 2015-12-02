defmodule Jumble.Picker do
  alias Jumble.PickTree

  def start_next_word(rem_letters, word_length, stash_pid) do
    {initial_valid_picks, initial_downstream_picks} =
      rem_letters
      |> Enum.split(1 - word_length)

    {initial_valid_picks, initial_downstream_picks, []}
    |> pick_letters(stash_pid)
  end

  def pick_letters({last_valid_picks, [], acc_letters}, stash_pid) do
    last_valid_picks
    |> Enum.each(fn(last_pick) ->
      stash_pid
      |> PickTree.next_root_state([last_pick | acc_letters])
      |> case do
        {next_rem_letters, next_word_length, next_stash_pid} ->
          next_rem_letters
          |> start_next_word(next_word_length, next_stash_pid)

        {:done, words} ->
          words
          |> PickTree.push_raw_result
      end
    end)
  end

  def pick_letters({valid_picks, [valid_next | rem_downstream_picks], acc_letters}, stash_pid) do
    valid_picks
    |> map_picks_with_next_valid_picks(valid_next)
    |> Enum.each(fn({pick, next_valid_picks}) ->
      {next_valid_picks, rem_downstream_picks, [pick | acc_letters]}
      |> pick_letters(stash_pid)
    end)
  end

  def map_picks_with_next_valid_picks(valid_picks, valid_next) do
    intial_picks_acc =
      valid_picks
      |> List.insert_at(-1, valid_next)
 
    valid_picks
    |> Enum.scan({nil, intial_picks_acc}, fn(pick, {_last_pick, last_pick_acc}) ->

      {pick, tl(last_pick_acc)}
    end)
  end
end
