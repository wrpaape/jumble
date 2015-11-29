# defmodule Jumble.Generate do
#   defmacro char_pools(jumble_maps) do
#     {generators, do_clause} =
#       jumble_maps
#       |> Enum.sort_by({_jumble, %{jumble_index: jumble_index}} ->
#         -jumble_index
#       end)
#       |> Enum.map_reduce({[], []}, fn({jumble, %{unjumbleds: unjumbleds}}, {keys_clause, values_clause}) ->
#         unjumbled = jumble <> "_unjumbled"
#         key_letters = jumble <> "_key_letters"

#         keys_clause = 
#           quote do: unquote([unjumbled | keys_clause])

#         values_clause =
#           quote do: unquote(values_clause) ++ unquote(key_letters)
        
#         {quote do: unquote({unjumbled, key_letters}) <- unquote(unjumbleds), }
#       end)

#     quote do
#       for 

#     end
#   end
# end

# defmodule Foo do
#   def combine(list_of_lists) do
#     {lists_with_lengths, num_combs} =
#       list_of_lists
#       |> Enum.map_reduce(1, fn(list, acc) ->
#         length_list =
#           list
#           |> length

#         {{list, length_list}, acc * length_list}
#       end)

#     lists_with_lengths
#     |> Enum.map(fn({list, length_list}) ->
#       num_dups =
#         num_combs
#         |> div(length_list)

#       list
#       |> Enum.flat_map(fn(el) ->
#         el
#         |> List.duplicate(num_dups)
#       end)
#     end)
#     # |> List.zip
#   end
# end
# # [[1, -5], [2, -4], [3, -5], [1, -4], [2, -5], [3, -4]]
# lol = [[1, 2, 3], [-5, -4], [5, 6, 7, 8, 9], '\n\t\b']
# # lol = [[1, 2, 3], [-5, -4]]
# Foo.combine(lol)

# defmodule Foo do
#   def combinations([last_list | []], els, acc) do
#     last_list
#     |> Enum.reduce(acc, fn(last_el, last_acc) ->
#       [[last_el | els] | last_acc]
#     end)
#   end

#   def combinations([head_list | tail_lists], els \\ [], acc \\ []) do
#     head_list
#     |> Enum.reduce(acc, fn(el, next_acc) ->
#       combinations(tail_lists, [el | els], next_acc)
#     end)
#   end
# end




