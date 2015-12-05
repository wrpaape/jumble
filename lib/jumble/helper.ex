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

  def with_index(collection, initial) do
    collection
    |> Enum.map_reduce(initial, fn(el, acc) ->
      {{el, acc}, acc + 1}
    end)
    |> elem(0)
  end

  def with_index(collection, initial, :leading) do
    collection
    |> Enum.map_reduce(initial, fn(el, acc) ->
      {{acc, el}, acc + 1}
    end)
    |> elem(0)
  end

  def with_counter(collection, initial) do
    collection
    |> Enum.reduce({[[], []], initial}, fn(el, {[acc_els, acc_counters], counter}) ->

      {[[el | acc_els], [counter | acc_counters]], counter + 1}
    end)
    |> elem(0)
  end

  def partition_dups_by_val(keyword) do
    keyword
    |> Enum.reduce({[], [], HashSet.new}, fn(el = {_key, val}, {uniqs, dups, uniq_vals})->
      if Set.member?(uniq_vals, val) do
        {uniqs, [el | dups], uniq_vals}
      else
        {[el | uniqs], dups, Set.put(uniq_vals, val)}
      end
    end)
    |> Tuple.delete_at(2)
  end

  def wrap_prepend(second, first), do: {first, second}
  def wrap_append(first, second),  do: {first, second}
end







