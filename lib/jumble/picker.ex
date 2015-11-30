defmodule Jumble.Picker do

  def start_tree(rem_letters, picks_remaining, rem_num_picks) do
    rem_letters
    # |> Enum.sort
    |> Helper.split_list_at(length(pick_pool) - word_length)
    |>

  end

  # def next_picks(pool, acc_word) when Enum.empty?(pool), do: acc_word

  def generate_word_pools(pool, word_length) do
    {possible_next_picks, next_pool} =
      pool
      |> Helper.part_dups

    possible_next_picks
    |> Enum.map(fn({index, pick}) ->
      {Map.delete(pool, index), acc_word <> pick, rem_num_picks - 1}

      unique_string_ids(word_length)
    end)

  end

  def unique_string_ids(next_picks, rem_num_picks) do

  end


  def next_picks({leftover_pool, finished_word, 0}), do: {Helper.string_id(, leftover_pool}
  def next_picks({pool, acc_word, rem_num_picks}, top_level_acc) do
    pool
    |> Enum.map(fn({index, pick}) ->
      {Map.delete(pool, index), acc_word <> pick, rem_num_picks - 1}
      |> next_picks(top_level_acc)
    end)
    |> next_picks(top_level_acc)
  end
end


defmodule Foo do
  def picks_and_next_pools([el1, el2]),   do: [{el1, [el2]}]
  def picks_and_next_pools([head | tail]), do: [{head, tail} | picks_and_next_pools(tail)]

  def partition_dup_keys(map) do
    map
    |> Enum.reduce({%{}, %{}, %HashSet{}}, fn({key, val}, {uniq_map, dup_map, uniq_set}) ->
      if Set.member?(uniq_set, val) do
        {uniq_map, Map.put(dup_map, key, val), uniq_set}
      else
        {Map.put(uniq_map, key, val), dup_map, Set.put(uniq_set, val)}
      end
    end)
    |> Tuple.delete_at(2)
  end
end

Foo.picks_and_next_pools(1..5 |> Enum.to_list)