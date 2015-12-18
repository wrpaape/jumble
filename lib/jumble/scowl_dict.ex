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
    uniq_sol_length_strs =
      sol_lengths
      |> Enum.uniq
      |> Enum.map(&{&1, Integer.to_string(&1)})

    uniq_jumble_lengths
    |> build_length_dict
    |> Helper.wrap_append(uniq_sol_length_strs)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_call({:safe_get, length_word, string_id}, _from, state = {length_dict, _sol_length_tups}) do
    valid_words =
      length_dict
      |> Map.get(length_word)
      |> Enum.find_value(&apply(&1, :get, [string_id]))

    {:reply, valid_words, state}
  end

  def handle_call({:rank_picks, picks}, from, {[head_rank_fun | tail_rank_funs], dict_builder}) do
    picks
    |> Enum.reduce({HashSet.new, Map.new}, fn(pick = [head_id | tail_ids], {ranks_set, ranked_picks})->
      head_rank =
        head_rank_fun.(head_id)

      pick_rank =
        tail_ids
        |> Enum.reduce({head_rank, tail_rank_funs}, fn(id, {max_rank, [next_rank_fun | rem_rank_funs]})->
          next_rank_fun.(id)
          |> max(max_rank)
          |> Helper.wrap_append(rem_rank_funs)
        end)
        |> elem(0)

      ranks_set
      |> Set.member?(pick_rank)
      |> if do
        ranked_picks
        |> Map.update!(pick_rank, &{limited_dict, [pick | &1]})
        |> Helper.wrap_prepend(ranks_set)
      else
        ranked_picks
        |> Map.put(pick_rank, {dict_builder(pick_rank), [pick]})
        |> Helper.wrap_prepend(Set.put(ranks_set, pick_rank))
      end
    end)
  end

  def handle_cast(:swap_dict, {_drop_dict, sol_length_tups}) do
    limited_dict_builder = 
      fn(min_size)->
        size_domain =
          @dict_sizes
          |> Enum.drop_while(&1 < min_size)

        sol_length_tups
        |> Enum.reduce(Map.new, fn({length_int, length_str}, length_dict)->
          size_dict =
            size_domain
            |> Enum.map(&size_dict_module(&1, length_str))

          length_dict
          |> Map.put(length_int, size_dict)
        end)
      end

    rank_funs =
      sol_lengths
      |> Enum.map(fn(length)->
        next_length_dict
        |> Map.get(length)
        |> build_rank_fun
      end)

    
    {:noreply, {rank_funs, limited_dict_builder}, :hibernate}
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

