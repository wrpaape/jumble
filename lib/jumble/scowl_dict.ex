defmodule Jumble.ScowlDict do
  @dict_sizes Application.get_env(:jumble, :scowl_dict_sizes)
  @max_size   List.last(@dict_sizes)

  @uniq_jumble_lengths_key_path ~w(jumble_info uniq_lengths)a

  use GenServer
  alias Jumble.Helper
   
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def safe_id_validator(length_word) do
    safe_size_dict_module =
      length_word
      |> safe_size
    
    &safe_size_dict_module.valid_id?/1
  end

  def start_link(args) do
    __MODULE__
    |> GenServer.start_link(args, name: __MODULE__)

    args
  end

  def safe_get(length_word, string_id),  do: GenServer.call(__MODULE__, {:safe_get, length_word, string_id})

  def shutdown,                          do: GenServer.cast(__MODULE__, :shutdown)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(args) do
    args
    |> get_in(@uniq_jumble_lengths_key_path)
    |> build_length_dict
    |> Helper.wrap_prepend(:ok)
  end

  def handle_call({:safe_get, length_word, string_id}, _from, length_dict) do
    valid_words =
      length_dict
      |> Map.get(length_word)
      |> Enum.find_value(&apply(&1, :get, [string_id]))

    {:reply, valid_words, length_dict}
  end

  def handle_cast(:shutdown, _drop_dict), do: exit(:normal)

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp size_dict_module(size_str, length_str) do
    [__MODULE__, "Size" <> size_str, "Length" <> length_str]
    |> Module.safe_concat
  end

  defp build_length_dict(lengths, builder_fun) do
    lengths
    |> Enum.reduce(Map.new, fn(length, size_dicts)->
      size_dicts
      |> Map.put(length, all_sizes(length))
    end)
  end

  defp all_sizes(length_word) do
    length_str =
      length_word
      |> Integer.to_string

    @dict_sizes
    |> Enum.map(&size_dict_module(&1, length_str))
  end

  def safe_size(length_word) do
    length_str =
      length_word
      |> Integer.to_string

    @max_size
    |> size_dict_module(length_str)
  end
end

