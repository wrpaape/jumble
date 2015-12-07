defmodule Jumble.Helper do
  def string_id(string) do
    string
    |> String.codepoints
    |> Enum.sort
    |> Enum.join
  end
  
  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def wrap_prepend(second, first), do: {first, second}
  def wrap_append(first, second),  do: {first, second}

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
end







