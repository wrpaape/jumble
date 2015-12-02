defmodule Jumble.LengthDict do
  def get(length_word, string_id) do
    __MODULE__
    |> Agent.get(Map, :get, [length_word])
    |> apply(:get, [string_id]) || []
  end

  def start_link(%{sol_info: %{uniq_lengths: uniq_sol_lengths}, jumble_info: %{uniq_lengths: uniq_jumble_lengths}} = args) do
    lengths_domain =
      uniq_sol_lengths
      |> Set.union(uniq_jumble_lengths)

    __MODULE__
    |> Agent.start_link(:build_dict, [lengths_domain], name: __MODULE__)

    args
  end

  def build_dict(lengths) do
    lengths
    |> Enum.map(fn(length) ->
      module_string =
        "Length"
        <> Integer.to_string(length)

      name_spaced_module =
        __MODULE__
        |> Module.safe_concat(module_string)

      {length, name_spaced_module}
    end)
    |> Enum.into(Map.new)
  end
end
