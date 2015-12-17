defmodule Jumble.ScowlDict do
  @dict_sizes Application.get_env(:jumble, :scowl_dict_sizes)
  @max_size   List.last(@dict_sizes)

  # @uniq_jumble_lengths_key_path ~w(jumble_info uniq_lengths)a

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

  # def safe_getter(length_word) do
  #   all_size_dict_modules =
  #     length_word
  #     |> all_sizes

    # fn(string_id)->
    #   all_size_dict_modules
    #   |> Enum.find_value(&apply(&1, :get, [string_id]))
    # end
  # end

  def start_link(args) do
    __MODULE__
    |> GenServer.start_link(args, name: __MODULE__)

    args
  end

  def safe_get(length_word, string_id),  do: GenServer.call(__MODULE__, {:safe_get, length_word, string_id})

  def rank_picks(picks),                 do: GenServer.call(__MODULE__, {:rank_picks, picks})

  def swap_dict,                         do: GenServer.cast(__MODULE__, :swap_dict)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(%{sol_info: %{sol_lengths: sol_lengths}, jumble_info: %{uniq_lengths: uniq_jumble_lengths}}) do
    uniq_jumble_lengths
    |> build_length_dict
    |> Helper.wrap_append(sol_lengths)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_call({:safe_get, length_word, string_id}, _from, state = {length_dict, _sol_lengths}) do
    valid_words =
      length_dict
      |> Map.get(length_word)
      |> Enum.find_value(&apply(&1, :get, [string_id]))

    {:reply, valid_words, state}
  end

  def handle_call({:rank_picks, picks}, [first_rank_fun | tail_rank_funs]) do
    picks
    |> Enum.reduce(Map.new, fn(pick = [first_id | rem_ids], ranked_picks)->
      first_rank =
        first_rank_fun.(first_id)

      pick_rank =
        rem_ids
        |> Enum.reduce({first_rank, tail_rank_funs}, fn(id, {max_rank, [next_rank_fun | rem_rank_funs]})->
          next_rank_fun.(id)
          |> max(max_rank)
          |> Helper.wrap_append(rem_rank_funs)
        end)
        |> elem(0)

      ranked_picks
      |> Map.update(pick_rank, [pick], &[pick | &1])
    end)
  end

  def handle_cast(:swap_dict, {_drop_dict, sol_lengths}) do
    next_length_dict = 
      sol_lengths
      |> Enum.uniq
      |> build_length_dict

    rank_funs =
      sol_lengths
      |> Enum.map(fn(length)->
        next_length_dict
        |> Map.get(length)
        |> build_rank_fun
      end)

    
    {:noreply, rank_funs, :hibernate}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#


  defp build_rank_fun(size_dicts) do
    validators =
      size_dicts
      |> Enum.map(fn(size_dict)->
        &size_dict.valid_id?/1
      end)

    fn(string_id)->
      validators
      |> Enum.reduce_while(1, fn(valid_id?, index)->
        if valid_id?.(string_id) do
          {:halt, index}
        else
          {:cont, index + 1}
        end
      end)
    end
  end

  defp size_dict_module(size_str, length_str) do
    [__MODULE__, "Size" <> size_str, "Length" <> length_str]
    |> Module.safe_concat
  end

  defp build_length_dict(lengths) do
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

