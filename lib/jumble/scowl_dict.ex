defmodule Jumble.ScowlDict do
  @dict_sizes Application.get_env(:jumble, :scowl_dict_sizes)

  alias Jumble.Helper
   
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def safe_get(length_word, string_id) do
    [length_word, :all_modules]
    |> get_in_agent
    |> Enum.find_value(&get_in_dict(&1, string_id))
  end

  def limited_get(length_word, string_id) do
    [length_word, :limited_module]
    |> get_in_agent
    |> get_in_dict(string_id)
  end

  def safe_valid_id?(length_word, string_id) do
    [length_word, :safe_valid_ids]
    # |> get_in_agent
    |> valid_id?(string_id)
  end

  def limited_valid_id?(length_word, string_id) do
    [length_word, :limited_valid_ids]
    |> valid_id?(string_id)
  end

  def update_limit do
    __MODULE__
    |> Agent.update(__MODULE__, :update_limit, [])
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

  def update_limit(scowl_dict) do
    scowl_dict
    |> Enum.reduce(Map.new, fn({length, sizes_map}, next_scowl_dict)->
      {[{next_limited_module, next_valid_ids}], trans_sizes_map} =
        sizes_map
        |> Map.get_and_update(:rem_limits, &Enum.split(&1, 1))

      next_sizes_map =
        trans_sizes_map
        |> Map.put(:limited_module, next_limited_module)
        |> Map.put(:limited_valid_ids, next_valid_ids)

      next_scowl_dict
      |> Map.put(length, next_sizes_map)
    end)
  end

  def reset_limit

  def build_dicts(lengths) do
    lengths
    |> Enum.reduce(Map.new, fn(length, scowl_dict) ->
      length_module =
        "Length"
        <> Integer.to_string(length)

        {all_modules, [{limited_module, valid_ids} | rem_limits]} =
          @dict_sizes
          |> List.foldr({[], []}, fn(dict_size, {modules, limits})->
            module =
              dict_size
              |> build_module(length_module)

            valid_ids =
              module
              |> apply(:valid_ids, [])

            {[module | modules], [{module, valid_ids} | limits]}
          end)

      safe_valid_ids =
        rem_limits
        |> List.last
        |> elem(1)

      sizes_map =
        Map.new
        |> Map.put(:all_modules, all_modules)
        |> Map.put(:limited_module, limited_module)
        |> Map.put(:limited_valid_ids, valid_ids)
        |> Map.put(:rem_limits, rem_limits)
        |> Map.put(:safe_valid_ids, safe_valid_ids)

      scowl_dict
      |> Map.put(length, sizes_map)
    end)
  end


####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  defp valid_id?(valid_id_key_path, string_id) do
    valid_id_key_path
    |> get_in_agent
    |> Set.member?(string_id)
  end

  defp build_module(dict_size, length_module) do
    [__MODULE__, "Size" <> dict_size, length_module]
    |> Module.safe_concat
  end

  defp get_in_agent(key_path), do: Agent.get(__MODULE__, Kernel, :get_in, [key_path])

  defp get_in_dict(dict_size_module, string_id) do
    dict_size_module
    |> apply(:get, [string_id])
  end
end
