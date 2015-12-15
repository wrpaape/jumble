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
    [length_word, :limit_module]
    |> get_in_agent
    |> get_in_dict(string_id)
  end

  def valid_id?(length_word, string_id) do
    [length_word, :valid_ids]
    |> get_in_agent
    |> Set.member?(string_id)
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
      {[{next_limit_module, next_valid_ids}], trans_sizes_map} =
        sizes_map
        |> Map.get_and_update(:rem_limits, &Enum.split(&1, 1))

      next_sizes_map =
        trans_sizes_map
        |> Map.put(:limit_module, next_limit_module)
        |> Map.put(:valid_ids, next_valid_ids)

      next_scowl_dict
      |> Map.put(length, next_sizes_map)
    end)
  end

  def build_dicts(lengths) do
    lengths
    |> Enum.reduce(Map.new, fn(length, scowl_dict) ->
      length_module =
        "Length"
        <> Integer.to_string(length)

        {all_modules, [{limit_module, valid_ids} | rem_limits]} =
          @dict_sizes
          |> List.foldr({[], []}, fn(dict_size, {modules, limits})->
            module =
              [__MODULE__, "Size" <> dict_size, length_module]
              |> Module.safe_concat

            valid_ids =
              module
              |> apply(:valid_ids, [])

            {[module | modules], [{module, valid_ids} | limits]}
          end)

      sizes_map =
        Map.new
        |> Map.put(:all_modules, all_modules)
        |> Map.put(:limit_module, limit_module)
        |> Map.put(:valid_ids, valid_ids)
        |> Map.put(:rem_limits, rem_limits)

      scowl_dict
      |> Map.put(length, sizes_map)
    end)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  def get_in_agent(key_path), do: Agent.get(__MODULE__, Kernel, :get_in, [key_path])

  def get_in_dict(dict_size_module, string_id) do
    dict_size_module
    |> apply(:get, [string_id])
  end
end
