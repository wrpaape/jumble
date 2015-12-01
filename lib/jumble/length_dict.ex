defmodule Jumble.LengthDict do
  alias Jumble.Helper

  def get(length_word, string_id) do
    __MODULE__
    |> Agent.get(Map, :get, [length_word])
    |> apply(:get, [string_id])
  end

  def start_link(%{final_lengths: final_lengths, jumble_maps: jumble_maps} = args) do
    uniq_lengths =
      jumble_maps
      |> Enum.map(fn({_jumble, %{length: length}}) ->
        length
      end)
      |> Enum.into(final_lengths)
      |> Enum.uniq

    __MODULE__
    |> Agent.start_link(:build_dict, [uniq_lengths], name: __MODULE__)

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

  # def build_dict(lengths) do
  #   lengths
  #   |> Enum.map_join("|",fn(length) ->
  #     length
  #     |> Integer.to_string
  #     |> Helper.cap("\\w{", "}")
  #   end)
  #   |> Helper.cap("\\b(", ")\\b")
  #   |> Regex.compile!
  #   |> Regex.scan(@dict, capture: :all_but_first)
  #   |> List.flatten
  #   |> Enum.group_by(&byte_size/1)
  # end
end
