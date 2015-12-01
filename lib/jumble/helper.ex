defmodule Jumble.Helper do
  def string_id(string) do
    string
    |> String.codepoints
    |> sort_join
  end
  def sort_join(list) do
    list
    |> Enum.sort
    |> Enum.join
  end

  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def pad(pad_length), do: String.duplicate(" ", pad_length)

  def with_index(collection, initial) do
    collection
    |> Enum.map_reduce(initial, fn(el, acc) ->
      {{el, acc}, acc + 1}
    end)
    |> elem(0)
  end

  def with_index(collection, initial, :lead) do
    collection
    |> Enum.map_reduce(initial, fn(el, acc) ->
      {{acc, el}, acc + 1}
    end)
  end

  def combinations([last_list | []], els, acc) do
    last_list
    |> Enum.reduce(acc, fn(last_el, last_acc) ->
      [[last_el | els] | last_acc]
    end)
  end

  def combinations([head_list | tail_lists], els \\ [], acc \\ []) do
    head_list
    |> Enum.reduce(acc, fn(el, next_acc) ->
      combinations(tail_lists, [el | els], next_acc)
    end)
  end

  def permutations(list, ks) do
    set =
      list
      |> List.to_tuple

  end

  def generate_pool_map(letters) do
    letters
    |> with_index(1, :lead)
    |> Enum.into(Map.new)
    |> with_uniqs_cache
  end

  def shift_times({list1, list2}, 0), do: {Enum.reverse(list1), list2}
  def shift_times({list1, [list2_head | list2_tail]}, num_shifts) do
    {[list2_head | list1], list2_tail}
    |> shift_times(num_shifts - 1)
  end

  def split_list_at(list, split_index) do
    {[], list}
    |> shift_times(split_index)
  end

  def partition_by_dup_vals(map) do
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

  def with_uniqs_cache(list) do
    list
    |> Enum.reduce(%{uniq_sorted: []}, fn(el, acc_map) ->
      acc_map
      |> Map.update!(:uniq_sorted, fn(uniq) ->
        if el in uniq, do: uniq, else: [el | uniq]
      end)
      |> Map.update(el, 1, &(&1 + 1))
    end)
    |> Map.update!(:uniq_sorted, &Enum.sort/1)
  end

  # def update_uniq_sorted(map, el) do
    # map
    # |> Map.get(:uniq_sorted)
    # |> case
  # end

  def reset_uniq_sorted(map, el) do
    map
    |> Map.get(el)
    |> case do
      0 -> map
        |> Map.update!(:uniq_sorted, &List.delete(&1, el))

      1 -> map
        |> Map.update!(:uniq_sorted, fn(uniq_sorted) ->
          uniq_sorted
          |> Enum.split_while(&(&1 < el))
          |> case do
            {_less_than_el, [^el | _greater_than_el]} -> uniq_sorted
            {less_than_el,  greater_than_el} ->
              less_than_el
              |> Enum.concat([el | greater_than_el])
          end
        end)

      _ -> map
    end
  end


  def inverse_and_merge(map) do
    map
    |> Enum.reduce(map, fn({key, val}, acc_map) ->
      acc_map
      |> Map.update(val, [key], fn(key_list) ->
        [key | key_list]
      end)
    end)
  end
end







