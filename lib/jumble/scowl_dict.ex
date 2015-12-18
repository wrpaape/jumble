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

  def handle_call({:rank_picks, picks}, from, {[head_rank_fun | tail_rank_funs], dict_builder}) do
    picks
    |> Enum.reduce({Map.new, HashSet.new}, fn(pick = [head_id | tail_ids], {ranked_picks, ranks_set})->
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
        |> Map.update!(pick_rank, fn({limited_dict, picks})->
          {limited_dict, [pick | picks]}
        end)
        |> Helper.wrap_append(ranks_set)
      else
        ranked_picks
        |> Map.put(pick_rank, {dict_builder.(pick_rank), [pick]})
        |> Helper.wrap_append(Set.put(ranks_set, pick_rank))
      end
    end)
    |> elem(0)
    |> Enum.sort
    |> reply_and_shutdown
  end

  def handle_cast(:swap_dict, {_drop_dict, sol_lengths}) do
    {uniq_lengths_tups, rank_funs} =
      sol_lengths
      |> Enum.reduce({HashSet.new, [], []}, fn(length_int, {dup_set, uniq_lengths_tups, rank_funs})->
        dup_set
        |> Set.member?(length_int)
        |> if do
          next_size_dicts = 
            length_int
            |> all_sizes
        else
          dup_set =
            dup_set
            |> Set.put(length_int)

          length_str =
            Integer.to_string(length_int)

          uniq_lengths_tups =
            [{length_int, length_str} | uniq_lengths_tups]

          next_size_dicts = 
            @dict_sizes
            |> build_size_dicts(length_str)
        end

        next_rank_fun =
          next_size_dicts
          |> build_rank_fun

        {dup_set, uniq_lengths_tups, [next_rank_fun | rank_funs]}
      end)
      |> Tuple.delete_at(0)

    limited_dict_builder = 
      fn(min_size)->
        size_domain =
          @dict_sizes
          |> Enum.drop_while(&(&1 < min_size))

        uniq_lengths_tups
        |> Enum.reduce(Map.new, fn({length_int, length_str}, length_dict)->
          size_dicts =
            size_domain
            |> build_size_dicts(length_str)

          length_dict
          |> Map.put(length_int, size_dicts)
        end)
      end

    {:noreply, {rank_funs, limited_dict_builder}, :hibernate}
  end

  def reply_and_shutdown(ranked_picks), do: {:stop, :normal, ranked_picks, ranked_picks}

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

  defp build_size_dicts(size_domain, length_str) do
    size_domain
    |> Enum.map(&size_dict_module(&1, length_str))
  end

  defp all_sizes(length_int) do
    @dict_sizes
    |> build_size_dicts(Integer.to_string(length_int))
  end

  def safe_size(length_int) do
    length_str =
      length_int
      |> Integer.to_string

    @max_size
    |> size_dict_module(length_str)
  end
end

