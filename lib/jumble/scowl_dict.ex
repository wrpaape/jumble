defmodule Jumble.ScowlDict do
  # @dict_size_modules Enum.map([Small, Medium, Large], &Module.safe_concat(__MODULE__, &1))
  @dict_size_modules [Small, Medium, Large]
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def safe_get(length_word, string_id) do
    __MODULE__
    |> Agent.get(Map, :get, [length_word])
    |> Enum.find_value(fn(scowl_dict_module)->
      scowl_dict_module
      |> apply(:get, [string_id])
    end)
  end

  def start_link(args = %{sol_info: %{uniq_lengths: uniq_sol_lengths}, jumble_info: %{uniq_lengths: uniq_jumble_lengths}}) do
    lengths_domain =
      uniq_sol_lengths
      |> Set.union(uniq_jumble_lengths)

    __MODULE__
    |> Agent.start_link(:build_dicts, [lengths_domain], name: __MODULE__)

    args
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def build_dicts(lengths) do
    lengths

    |> Enum.map(fn(length) ->
      length_module =
        "Length"
        <> Integer.to_string(length)

      name_spaced_modules =
        [Small, Medium, Large]
        |> Enum.map(fn(size_module)->
          [__MODULE__, size_module, length_module]
          |> Module.safe_concat
      end)

      {length, name_spaced_modules}
    end)
    |> Enum.into(Map.new)
  end
end
