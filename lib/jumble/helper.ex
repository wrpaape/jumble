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

  def shift_times({list1, list2}, 0), do: {Enum.reverse(list1), list2}
  def shift_times({list1, [list2_head | list2_tail]}, num_shifts) do
    {[list2_head | list1], list2_tail}
    |> shift_times(num_shifts - 1)
  end

  def split_list_at(list, split_index) do
    {[], list}
    |> shift_times(split_index)
  end

  def pick_next_letter({next_word_pick_pool, downstream}, 0, string_id, acc_string_ids, acc_answer_ids) do
    next_word_lengths
    |> pick_next_word(next_word_pick_pool, [string_id | acc_string_ids], acc_answer_ids)
  end

  def pick_next_letter({pick_pool = [_dropped | pick_pool_tail], [downstream_head | next_downstream]}, num_rem_picks, string_id \\ "", acc_string_ids \\ [], acc_answer_ids \\ []) do
    pick_pool
    |> Enum.map(fn(pick) ->
      next_pick_pool =
        pick_pool_tail
        |> List.insert_at(-1, downstream_head)

      {next_pick_pool, next_downstream}
      |> pick_next_letter(num_rem_picks - 1, string_id <> pick, acc_string_ids, acc_answer_ids)
    end)


    pick <> pick_next_letter( num_rem_picks - 1)
  end


  def pick_next_word([], [], unique_string_ids), do: unique_string_ids

  def pick_next_word([word_length | next_word_lengths], pick_pool, acc_answer_ids) do
    pick_pool
    |> split_list_at(length(pick_pool) - word_length)
    |> pick_next_letter(word_length, acc_answer_ids)
  end

  def pick_next_answer_ids([], _, acc_answer_ids), do: acc_answer_ids

  def pick_next_answer_ids(pick_lengths, initial_word_bank, acc_answer_ids \\ []) do
    pick_lengths
    |> pick_next_word(initial_word_bank, [])
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

  # def generate_pick_pools([]), do: []
  # def generate_pick_pools(pool = [_dropped | next_pools]) do
  #   [pool | generate_pick_pools(next_pools)]
  # end
  # 3 / 4 / 4
  # ["y", "w", "e", "j", "o", "l", "n", "d", "b", "e", "a"]
end















