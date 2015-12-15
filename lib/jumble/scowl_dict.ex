defmodule Jumble.ScowlDict do
  @dict_size_modules Application.get_env(:jumble, :scowl_dict_sizes)
   |> Enum.map(&Module.concat(__MODULE__, "Size" <> &1))
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def safe_get(length_word, string_id) do
    [length_word, :all]
    |> get_in_agent
    |> Enum.find_value(&get_in_dict(&1, string_id))
  end

  def limited_get(length_word, string_id) do
    [length_word, :size_limit]
    |> get_in_agent
    |> get_in_dict(string_id)
  end

  def update_limit do
    __MODULE__
    |> Agent.update(fn(scowl_dict)->
      scowl_dict
      |> Enum.reduce(Map.new, fn({length, sizes_map}, next_scowl_dict)->
        {next_size_limit, trans_sizes_map} =
          sizes_map
          |> Map.get_and_update(:rem_limits, &Enum.split(&1, 1))

        next_sizes_map =
          trans_sizes_map
          |> Map.put(:size_limit, next_size_limit)

        next_scowl_dict
        |> Map.put(length, next_sizes_map)
      end)
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
    |> Enum.reduce(Map.new, fn(length, scowl_dict) ->
      length_module =
        "Length"
        <> Integer.to_string(length)

      all_size_modules =
        [size_limit | rem_limits] =
          @dict_size_modules
          |> Enum.map(&Module.safe_concat(&1, length_module))

      sizes_map =
        Map.new
        |> Map.put(:all, all_size_modules)
        |> Map.put(:size_limit, size_limit)
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
