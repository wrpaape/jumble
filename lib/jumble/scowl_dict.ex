defmodule Jumble.ScowlDict do
  @dict_sizes Application.get_env(:jumble, :scowl_dict_sizes)
  @max_size   List.last(@dict_sizes)

  @uniq_jumble_lengths_key_path ~w(jumble_info uniq_lengths)a

  use GenServer
  alias Jumble.Helper
   
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  # def safe_dict(length_word) do
  #   safe_dict_module =
  #     length_word
  #     |> Integer.to_string
  #     |> build_safe_dict_module
    
  #   &safe_dict_module.valid_id?/1
  # end

  def start_link(args) do
    __MODULE__
    |> GenServer.start_link(args, name: __MODULE__)

    args
  end

  def safe_get(length_word, string_id), do: GenServer.call(__MODULE__, {:safe_get, length_word, string_id})


  # def safe_get(length_word, string_id) do
  #   length_word
  #   |> build_all_dicts
  #   |> Enum.find_value(&apply(&1, :get, [string_id]))
  # end
  
  def build_safe_dict_module(length_word) do
    length_str =
      length_word
      |> Integer.to_string

    @max_size
    |> build_dict_module(length_str)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(args) do
    args
    |> get_in(@uniq_jumble_lengths_key_path)
    |> Enum.reduce(Map.new, fn(length_word, all_dict_modules)->
      all_dict_modules
      |> Map.put(length_word, build_all_dicts(length_word))
    end)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_call({:safe_get, length_word, string_id}, _from, all_dict_modules) do
    valid_words =
      all_dict_modules
      |> Map.get(length_word)
      |> Enum.find_value(&apply(&1, :get, [string_id]))

    {:reply, valid_words, all_dict_modules}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#



  defp build_dict_module(size_str, length_str) do
    [__MODULE__, "Size" <> size_str, "Length" <> length_str]
    |> Module.safe_concat
  end

  defp build_all_dicts(length_word) do
    length_str =
      length_word
      |> Integer.to_string

    @dict_sizes
    |> Enum.map(&build_dict_module(&1, length_str))
  end
end

  # def safe_get(length_word, string_id) do
  #   length_word
  #   |> get_in_sizes_map(:all_modules)
  #   |> Enum.find_value(&apply_dict(&1, :get, string_id))
  # end

  # def limited_get(length_word, string_id) do
  #   length_word
  #   |> get_in_sizes_map(:limit_module)
  #   |> apply_dict(:get, string_id)
  # end

  # def safe_valid_id?(length_word, string_id) do
  #   length_word
  #   |> get_in_sizes_map(:last_module)
  #   |> apply_dict(:valid_id?, string_id)
  # end

  # def limited_valid_id?(length_word, string_id) do
  #   length_word
  #   |> get_in_sizes_map(:limit_module)
  #   |> apply_dict(:valid_id?, string_id)
  # end

  # def update_limit do
  #   __MODULE__
  #   |> Agent.update(__MODULE__, :update_limit, [])
  # end

  # def start_link(args = %{sol_info: %{uniq_lengths: uniq_sol_lengths}, jumble_info: %{uniq_lengths: uniq_jumble_lengths}}) do
  #   lengths_domain =
  #     uniq_sol_lengths
  #     |> Set.union(uniq_jumble_lengths)

  #   __MODULE__
  #   |> Agent.start_link(:build_dicts, [lengths_domain], name: __MODULE__)

  #   args
  # end



  # def update_limit(scowl_dict) do
  #   scowl_dict
  #   |> Enum.reduce(Map.new, fn({length, sizes_map}, next_scowl_dict)->

  #     {[next_limit_module], trans_sizes_map} =
  #       sizes_map
  #       |> Map.get_and_update(:rem_modules, &Enum.split(&1, 1))

  #       next_sizes_map =
  #         trans_sizes_map
  #         |> Map.put(:limit_module, next_limit_module)

  #     next_scowl_dict
  #     |> Map.put(length, next_sizes_map)
  #   end)
  # end


  # def build_dicts(lengths) do
  #   lengths
  #   |> Enum.reduce(Map.new, fn(length, scowl_dict) ->
  #     length_module =
  #       "Length"
  #       <> Integer.to_string(length)

  #       all_modules =
  #         [limit_module | rem_modules] =
  #           @dict_sizes
  #           |> Enum.map(&build_module(&1, length_module))

  #     sizes_map =
  #       Map.new
  #       |> Map.put(:all_modules, all_modules)
  #       |> Map.put(:limit_module, limit_module)
  #       |> Map.put(:rem_modules, rem_modules)
  #       |> Map.put(:last_module, List.last(rem_modules))

  #     scowl_dict
  #     |> Map.put(length, sizes_map)
  #   end)
  # end


####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  # defp build_module(dict_size, length_module) do
  #   [__MODULE__, "Size" <> dict_size, length_module]
  #   |> Module.safe_concat
  # end

  # defp get_in_sizes_map(length, key), do: Agent.get(__MODULE__, Kernel, :get_in, [[length, key]])

  # defp apply_dict(dict_module, fun, string_id) do
  #   dict_module
  #   |> apply(fun, [string_id])
  # end
