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

defmodule Foo do
  def pick_letter(next_word_pool, 1, finished_word) do
    IO.puts("finished")
    
    IO.inspect({next_word_pool, finished_word})
    finished_word
  end

  def pick_letter(rem_pool, drop_index, acc_word) do

    IO.inspect(rem_pool)
    IO.inspect(drop_index)
    IO.inspect(acc_word)

    rem_pool
    |> Enum.drop(drop_index)
    |> Enum.map_reduce(rem_pool, fn(next_pick, [_drop | next_rem_pool]) ->
      finished_word_combs =
        next_rem_pool
        |> pick_letter(drop_index + 1, acc_word <> next_pick)
      {finished_word_combs, next_rem_pool}
    end)
  end

  def next_word(next_word_pool, next_word_length) do
    next_word_pool
    |> Enum.sort
    |> pick_letter(1 - next_word_length, "")
  end

end
Foo.next_word(~w(a b c d e f), 3)

  def solve(initial_pool, [next_word_length | rem_word_lengths]) do
    initial_pool
    |> Enum.map
      next_answer()

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