defmodule Jumble.Solver do
  # def get(key) do
  #   __MODULE__
  #   |> Agent.get(Map, :get, [key])
  # end
  alias Jumble.Helper


  def solve do
    __MODULE__
    |> Agent.cast(&solve/1)
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    push = fn(unjumbleds) ->
      [{unjumbled, key_letters} | unjumbleds]
    end

    __MODULE__
    |> Agent.cast(Kernel, :update_in, [[:jumble_maps, jumble, :unjumbleds], push])
  end

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Map
    |> Agent.start_link(:update!, [args, :jumble_maps, into_map], name: __MODULE__)

    args
  end


  def solve(%{clue: clue, final_lengths: final_lengths, jumble_maps: jumble_maps}) do
    jumble_maps
    |> Enum.sort_by(fn({_jumble, %{jumble_index: jumble_index}}) ->
      jumble_index
    end)
    |> Enum.map(fn({jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Helper.combinations
    |> IO.inspect
    # |> Enum.map(fn(answers) ->
    #   answers
    #   |> Enum.flat_map_reduce("", fn({unjumbled, key_letters}, acc) ->
    #     {key_letters, acc <> "\n" <> unjumbled}
    #   end)
    # end)
    # |> Helper.permutations
    # |> IO.inspect
  end

  def pick_letter(rem_pool, drop_index, acc_word) do
    # {this_pool, [next_head | next_tail]} =
    #   rem_pool
    #   |> Enum.split(split_index)

    rem_pool
    |> Enum.drop(drop_index)
    |> Enum.map_reduce(tl(rem_pool), fn(next_pick, next_rem_pool) ->
      downstream_combs =
        next_rem_pool
        |> pick_letter(split_index - 1, acc_word <> next_pick)

      {downstream_combs, tl(next_rem_pool)}
    end)
  end

  def start_next_word(next_pool, next_word_length) do
    next_pool
    # |> Map.drop([:initial_pick_size, :last_letter_key])
    # |> Map.values
    |> Enum.sort
    |> pick_next_letter(1 - next_word_length, "")
  end

  def next_word_pool(rem_letters, next_word_length) do
    # {indexed_pool, pool_length_plus_one} =
      # |> Helper.with_index(1, :lead)
    # indexed_pool
    # |> Enum.into(Map.new)
              
    {Enum.sort(rem_letters), 

    # |> Map.put(:initial_pick_size, pool_length_plus_one - next_word_length)
    # |> Map.put(:last_letter_key, pool_length_plus_one - 1)
  end
end

# word_lengths = [3, 4, 4]
# letters = ["l", "w", "e", "j", "o", "l", "n", "d", "b", "e", "a"]
# Jumble.Picker.solve(letters, word_lengths)

# [[{"yawler", ["y", "w", "e"]}, {"major", ["j", "o"]},
#   {"gland", ["l", "n", "d"]}, {"becalm", ["b", "e", "a"]}],
#  [{"lawyer", ["l", "w", "e"]}, {"major", ["j", "o"]},
#   {"gland", ["l", "n", "d"]}, {"becalm", ["b", "e", "a"]}]]


# %{"camble" => %{jumble_index: 3, keys_at: [1, 2, 4], length: 6,
#     string_id: 'abcelm', unjumbleds: [{"becalm", ["b", "e", "a"]}]},
#   "nagld" => %{jumble_index: 1, keys_at: [2, 4, 5], length: 5,
#     string_id: 'adgln', unjumbleds: [{"gland", ["l", "n", "d"]}]},
#   "ramoj" => %{jumble_index: 2, keys_at: [3, 4], length: 5, string_id: 'ajmor',
#     unjumbleds: [{"major", ["j", "o"]}]},
#   "wraley" => %{jumble_index: 4, keys_at: [1, 3, 5], length: 6,
#     string_id: 'aelrwy',
#     unjumbleds: [{"lawyer", ["l", "w", "e"]}, {"yawler", ["y", "w", "e"]}]}}