defmodule Jumble.Helper do
  def string_id(string) do
    string
    |> String.codepoints
    |> Enum.sort
    |> Enum.join
  end

  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def pad(pad_length), do: String.duplicate(" ", pad_length)

  def with_index(collection, initial) do
    collection
    |> Enum.map_reduce(initial, fn(x, acc) ->
      {{x, acc}, acc + 1}
    end)
    |> elem(0)
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

  def pick_letter(next_pick, string_id) do
    next_pick <> string_id
  end

  def pick_unique_string_ids([pick_length | rem_pick_lengths], letter_bank) do
    letter_bank
    |> Enum.map_reduce("", fn(next_pick, {string_id, [next_pick | rem_letters]}) ->
      next_pick
      |> pick_letter()
    end)

    inital_pick_pool
    |> Enum.map
    |> next_pick
    
    pick_unique_string_ids(rem_pick_lengths, rem_letters)
  end

  def valid_answers(letter_bank, string_lengths) do

    string_lengths
    |> pick_unique_string_ids(Enum.sort(letter_bank))
    # |> Enum.map_reduce(Enum.sort(letters), fn(pick_length, rem_letters) ->
      # rem_letters
      # |> generate_pick_pools
      # |> Enum.map
      # |> Enum.reduce({"", rem_letters}, fn(pick_pool, {string_id, [next_letter | rem_letters]}) ->
      #   {string_id <> next_letter, rem_letters}
      # end)
    # |> Enum.map(fn())
    end)
  end

  def generate_pick_pools([]), do: []
  def generate_pick_pools(pool = [_dropped | next_pools]) do
    [pool | generate_pick_pools(next_pools)]
  end
  # 3 / 4 / 4
  # ["y", "w", "e", "j", "o", "l", "n", "d", "b", "e", "a"]
end















