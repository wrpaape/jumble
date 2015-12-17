defmodule Jumble.ScowlDict.Builder.ServerBuilder do
  defmacro build_server do
    quote do
      @dict __MODULE__
        |> Module.concat(Dict)
        |> apply(:get, [])

      @valid_ids @dict
        |> Map.keys
        |> Enum.into(HashSet.new)

      def get(string_id) do
        @dict
        |> Map.get(string_id)
      end

      def valid_id?(string_id) do
        @valid_ids
        |> Set.member?(string_id)
      end
    end
  end
end

# defmodule Jumble.ScowlDict.Builder.ServerBuilder do
#   defmacro build_server(size, length) do
#     module =
#       [Jumble, ScowlDict, "Size#{size}", "Length#{length}"]
#       |> Module.concat

#     quote do
#       defmodule unquote(module) do
#         @dict __MODULE__
#           |> Module.concat(Dict)
#           |> apply(:get, [])

#         @valid_ids @dict
#           |> Map.keys
#           |> Enum.into(HashSet.new)

#         def get(string_id) do
#           @dict
#           |> Map.get(string_id)
#         end

#         def valid_id?(string_id) do
#           @valid_ids
#           |> Set.member?(string_id)
#         end
#       end
#     end
#   end
# end