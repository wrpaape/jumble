defmodule Jumble.Picker do
  alias Jumble.PickTree

  def pick_letter(next_word_pool, 1, finished_letters, stash_pid) do
    IO.puts("finished word")
    IO.inspect({next_word_pool, finished_letters})

    stash_pid
    |> PickTree.next_root_state(finished_letters)
    |> case do
      {next_word_pool, next_word_length, next_stash_pid} ->
        __MODULE__
        |> spawn(:next_word, [next_word_pool, next_word_length, next_stash_pid])

      result ->
        result
        |> PickTree.report_result
    end

    Agent.stop(stash_pid)
  end

  def pick_letter(rem_pool, drop_index, acc_letters, stash_pid) do

    IO.inspect(rem_pool)
    IO.inspect(drop_index)
    IO.inspect(acc_letters)

    rem_pool
    |> Enum.drop(drop_index)
    |> Enum.map_reduce(rem_pool, fn(next_pick, [_drop | next_rem_pool]) ->
      finished_word_combs =
        next_rem_pool
        |> pick_letter(drop_index + 1, [next_pick | acc_letters])
      {finished_word_combs, next_rem_pool}
    end)
  end

  def next_word(next_word_pool, next_word_length, stash_pid) do
    next_word_pool
    |> Enum.sort
    |> pick_letter(1 - next_word_length, [], stash_pid)
  end
end

#   def solve(letters, [first_word_length | rem_word_lengths]) do
#     letters
#     |> generate_initial_pool_map
#     |> IO.inspect
#     |> next_picks(first_word_length, rem_word_lengths, [], [])
#   end

#   def generate_initial_pool_map(letters) do
#     letters
#     |> Helper.with_uniqs_cache
#   end

#   def next_picks(pool, 0, [], picked_letters, acc_words) do
#     IO.inspect(pool)
#     :timer.sleep 100

#     [Helper.sort_join(picked_letters) | acc_words]
#     |> IO.inspect
#   end

#   def next_picks(next_pool, 0, [next_word_length | rem_word_lengths], picked_letters, acc_words) do
#     next_pool
#     # |> Helper.update_uniq_sorted(next_pick)
#     |> next_picks(next_word_length, rem_word_lengths, [], [Helper.sort_join(picked_letters) | acc_words])
#   end

#   def next_picks(pool = %{valid_picks: valid_picks}, rem_num_picks, rem_word_lengths, acc_letters, acc_words) do
#     this_valid_picks = 
#     pool
#     |> Map.update!(pick, &(&1 - 1))
    
#     rem_picks
#     |> Enum.map(fn(next_pick) ->
#       pool
#       |> next_picks(rem_num_picks - 1, rem_word_lengths, [next_pick | acc_letters], acc_words)
#       # pool
#       # |> Helper.update_uniq_sorted(next_pick)
#     end)
#   end
# end

#   # def get_and_update_uniqs_cache(map, get_key) do
#   #   get_val = map[get_key]
    
#   #   {update_key, update_fun} =
#   #     if map[get_val] > 0 do
#   #       {get_val, &(&1 - 1)}
#   #     else
#   #       {:uniq_set, &Set.delete(&1, get_key)}
#   #     end

#   #   {get_val, Map.update(map, update_key, update_fun)}
#   # end

#   # def generate_word_pools(pool, word_length) do
#   #   unique_next_picks =
#   #     pool
#   #     |> Helper.keys_of_unique_vals

#   #   possible_next_picks
#   #   |> Enum.map(fn(index) ->
#   #     {pick, next_pool} =
#   #       pool
#   #       |> Map.pop(index)

#   #     {Map.delete(pool, index), acc_word <> pick, rem_num_picks - 1}

#   #     unique_string_ids(word_length)
#   #   end)

#   # end

# #   def unique_string_ids(next_picks, rem_num_picks) do

# #   end


# #   def next_picks({leftover_pool, finished_word, 0}), do: {Helper.string_id(, leftover_pool}
# #   def next_picks({pool, acc_word, rem_num_picks}, top_level_acc) do
# #     pool
# #     |> Enum.map(fn({index, pick}) ->
# #       {Map.delete(pool, index), acc_word <> pick, rem_num_picks - 1}
# #       |> next_picks(top_level_acc)
# #     end)
# #     |> next_picks(top_level_acc)
# #   end
# # end


# # defmodule Foo do
# #   def picks_and_next_pools([el1, el2]),   do: [{el1, [el2]}]
# #   def picks_and_next_pools([head | tail]), do: [{head, tail} | picks_and_next_pools(tail)]

# #   def partition_by_dup_vals(map) do
# #     map
# #     |> Enum.reduce({%{}, %{}, %HashSet{}}, fn({key, val}, {uniq_map, dup_map, uniq_set}) ->
# #       if Set.member?(uniq_set, val) do
# #         {uniq_map, Map.put(dup_map, key, val), uniq_set}
# #       else
# #         {Map.put(uniq_map, key, val), dup_map, Set.put(uniq_set, val)}
# #       end
# #     end)
# #     |> Tuple.delete_at(2)
# #   end

# #   def update_uniq_set(next_map = %{uniq_set: uniq_set}, last_pick) do
# #     next_map
# #     |> Map.update(:uniq_set)
# #   end

# #   def with_uniqs_cache(map) do
# #     map
# #     |> Enum.reduce(Map.put(map, :uniq_set, HashSet.new), fn({key, val}, acc_map) ->
# #       acc_map
# #       |> Map.update!(:uniq_set, &Set.put(&1, val))
# #       |> Map.update(val, 0, &(&1 + 1))
# #     end)
# #   end

# #   def keys_of_unique_vals(map) do
# #     map
# #     |> Enum.reduce({[], HashSet.new}, fn({key, val}, acc = {uniq_list, uniq_set}) ->
# #       if Set.member?(uniq_set, val) do
# #         acc
# #       else
# #         {[key | uniq_list], uniq_set |> Set.put(val)}
# #       end
# #     end)
# #     |> elem(0)
# #   end
# # end

# # Foo.picks_and_next_pools(1..5 |> Enum.to_list)