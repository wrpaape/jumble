defmodule Jumble.Picker do
  alias Jumble.PickTree
# word_lengths = [3, 4, 4]
# letters = ["l", "w", "e", "j", "o", "l", "n", "d", "b", "e", "a"]
# Jumble.PickTree.start_link(letters, word_lengths)

  def start_next_word(rem_letters, word_length, stash_pid) do
    {initial_valid_picks, initial_downstream_picks} =
      rem_letters
      |> Enum.split(1 - word_length)
    
    {initial_valid_picks, initial_downstream_picks, []}
    |> pick_letters(stash_pid)
  end


  # last letter of word
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
          |> PickTree.process_result
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