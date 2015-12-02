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

  def partition_dups(collection) do
    collection
    |> Enum.reduce({[], []}, fn(el, {uniqs, dups})->
      if el in uniqs do
        {uniqs, [el | dups]}
      else
        {[el | uniqs], dups}
      end
    end)

  end

  
  # def store_state(state) do
  #   Agent.start_link(fn ->
  #     state
  #   end)
  # end

  # def fetch_state(pid) do
  #   pid
  #   |> Agent.get(fn(last_state)->
  #     last_state
  #   end)
  # end

  # def permutations([last_el | []], acc), do: [last_el | acc]

  # def permutations(list = [next_el | tail]) do
  #   tail
  #   |> Enum.map(acc, fn(el, next_acc) ->
  #     permutations([el | tail], [next_el | acc])
  #   end)
  # end
end







