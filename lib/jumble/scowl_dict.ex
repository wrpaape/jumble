defmodule Jumble.ScowlDict do
  @dict_sizes Application.get_env(:jumble, :scowl_dict_sizes)
  @max_size   List.last(@dict_sizes)

  # @uniq_jumble_lengths_key_path ~w(jumble_info uniq_lengths)a

  use GenServer
  alias Jumble.Helper
   
##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def safe_id_validator(length_str) do
    safe_size_dict_module =
      length_str
      |> safe_size
    
    &safe_size_dict_module.valid_id?/1
  end

  def start_link(args) do
    __MODULE__
    |> GenServer.start_link(args, name: __MODULE__)

    args
  end

  def safe_get(length_str, string_id), do: GenServer.call(__MODULE__, {:safe_get, length_str, string_id})

  def rank_picks(picks),               do: GenServer.call(__MODULE__, {:rank_picks, picks})

  def swap_dict,                       do: GenServer.cast(__MODULE__, :swap_dict)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(%{sol_info: %{sol_lengths_strs: sol_lengths_strs}, jumble_info: %{uniq_lengths: uniq_jumble_lengths}}) do
    uniq_jumble_lengths
    |> build_length_dict
    |> Helper.wrap_append(sol_lengths_strs)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_call({:safe_get, length_int, string_id}, _from, state = {length_dict, _sol_lengths_strs}) do
    valid_words =
      length_dict
      |> Map.get(length_int)
      |> Enum.find_value(&apply(&1, :get, [string_id]))

    {:reply, valid_words, state}
  end

  def handle_call({:rank_picks, picks}, _from, {[head_rank_fun | tail_rank_funs], all_size_dicts}) do
    picks
    |> Enum.reduce({all_size_dicts, @max_size}, fn(pick = [head_id | tail_ids], {ranked_picks, min_max_rank})->
      head_rank = head_rank_fun.(head_id)

      pick_rank =
        tail_ids
        |> Enum.reduce({head_rank, tail_rank_funs}, fn(id, {max_rank, [next_rank_fun | rem_rank_funs]})->
          next_rank_fun.(id)
          |> max(max_rank)
          |> Helper.wrap_append(rem_rank_funs)
        end)
        |> elem(0)

      @dict_sizes
      |> Enum.drop_while(&(&1 < pick_rank))
      |> Enum.reduce(ranked_picks, fn(dict_size, next_ranked_picks)->
        next_ranked_picks
        |> Map.update!(dict_size, fn({getters, picks, count})->
          {getters, [pick | picks], count + 1}
        end)
      end)
      |> Helper.wrap_append(min(min_max_rank, pick_rank))
    end)
    |> reply_and_shutdown
  end

  def handle_cast(:swap_dict, {_drop_dict, sol_lengths_strs}) do
    rank_funs =
      sol_lengths_strs
      |> Enum.map(fn(length_str)->
        length_str
        |> all_sizes
        |> build_rank_fun
      end)

    all_size_dicts =
      @dict_sizes
      |> Enum.reduce(Map.new, fn(dict_size, size_dicts)->
        limited_getters =
          sol_lengths_strs
          |> Enum.map(fn(length_str)->
            limited_size_dict_module =
              dict_size
              |> size_dict_module(length_str)

            &limited_size_dict_module.get/1
          end)

        size_dicts
        |> Map.put(dict_size, {limited_getters, [], 0})
      end)

    {:noreply, {rank_funs, all_size_dicts}, :hibernate}
  end

  def reply_and_shutdown({ranked_picks, min_max_rank}) do
      reply_tup = 
        ranked_picks
        |> Enum.sort
        |> Helper.wrap_append(min_max_rank)

    {:stop, :normal, reply_tup, reply_tup}
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
      |> Enum.reduce_while(@dict_sizes, fn(valid_id?, [next_dict_size | rem_dict_sizes])->
        if valid_id?.(string_id) do
          {:halt, next_dict_size}
        else
          {:cont, rem_dict_sizes}
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
    |> Enum.reduce(Map.new, fn(length_int, size_dicts)->
      next_size_dict = 
        length_int
        |> Integer.to_string
        |> all_sizes

      size_dicts
      |> Map.put(length_int, next_size_dict)
    end)
  end

  defp all_sizes(length_str) do
    @dict_sizes
    |> Enum.map(&size_dict_module(&1, length_str))
  end

  defp safe_size(length_str) do
    @max_size
    |> size_dict_module(length_str)
  end
end

