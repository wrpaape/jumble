defmodule Jumble.ScowlDict.Size80.Length11 do
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
