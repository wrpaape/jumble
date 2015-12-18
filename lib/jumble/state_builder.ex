defmodule Jumble.StateBuilder do
    alias Jumble.Helper
    alias Jumble.ScowlDict
  # alias Jumble.Helper.Stats

  def build_state([clue_string | jumble_strings]) do
    sol_info =
      clue_string
      |> split_on_slashes(parts: 2)
      |> parse_arg_strings

    jumble_info =
      jumble_strings
      |> build_jumble_info

    Map.new        
    |> Map.put(:sol_info, sol_info)
    |> Map.put(:jumble_info, jumble_info)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################


  defp build_jumble_info(jumble_strings) do
    {jumble_maps, {uniq_jumble_lengths, unjumbleds_length, _index}} =
      jumble_strings
      |> Enum.map_reduce({HashSet.new, -1, 1}, fn(jumble_string, {uniq_jumble_lengths, unjumbleds_length, index})->
        {jumble, keys_at} =
          jumble_string
          |> parse_arg_strings

        length_jumble =
          jumble
          |> byte_size

        jumble_map =
          Map.new
          |> Map.put(:jumble_index, index)
          |> Map.put(:length, length_jumble)
          |> Map.put(:string_id, Helper.string_id(jumble))
          |> Map.put(:keys_at, keys_at)
          |> Map.put(:unjumbleds, [])

        uniq_jumble_lengths
        |> Set.put(length_jumble)
        |> Helper.wrap_append(unjumbleds_length + length_jumble + 1)
        |> Tuple.append(index + 1)
        |> Helper.wrap_prepend({jumble, jumble_map})
      end)

    Map.new
    |> Map.put(:jumble_maps, jumble_maps)
    |> Map.put(:uniq_lengths, uniq_jumble_lengths)
    |> Map.put(:unjumbleds_length, unjumbleds_length)
  end

  defp parse_arg_strings([clue, sol_lengths_string]) do
      {sol_lengths_tups, {sol_lengths = [first_sol_length | rem_sol_lengths], sol_lengths_strs}} =
        sol_lengths_string
        |> parse_ints_w_string

    {letter_bank_length, final_sol_length} =
      rem_sol_lengths
      |> Enum.reduce({first_sol_length * 2 + 3, first_sol_length}, fn(sol_length, {letter_bank_length, final_sol_length})->
        {letter_bank_length + sol_length * 2, final_sol_length + sol_length + 1}
      end)

    # {uniq_sol_lengths, dup_tail} =
    #   sol_lengths
    #   |> Helper.with_index(1, :leading)
    #   |> partition_dups_by_val

    # pick_orders =
    #   uniq_sol_lengths
    #   |> Stats.uniq_pick_orders(dup_tail)

    # uniq_lengths =
    #   uniq_sol_lengths
    #   |> Keyword.values
    #   |> Enum.into(HashSet.new)

    # counts_map =
    #   Map.new
    #   |> Map.put(:total, 0)
    #   |> Map.put(:max_group_size, 0)

    # brute_map =
    #   Map.new
    #   |> Map.put(:counts, counts_map)
    #   |> Map.put(:sols, [])

    Map.new
    |> Map.put(:clue, clue)
    |> Map.put(:letter_bank_length, letter_bank_length)
    |> Map.put(:final_length, final_sol_length + 3)
    |> Map.put(:sol_lengths, sol_lengths)
    |> Map.put(:sol_lengths_strs, sol_lengths_strs)
    |> Map.put(:sol_lengths_tups, sol_lengths_tups)
    # |> Map.put(:uniq_lengths, Enum.into(uniq_lengths, HashSet.new))
    # |> Map.put(:pick_orders, pick_orders)
    # |> Map.put(:invalid_ids, HashSet.new)
    # |> Map.put(:processed_raw, HashSet.new)
    # |> Map.put(:counts, counts_map)
    # |> Map.put(:sols, [])
  end

  defp parse_arg_strings(jumble_string) do
    [arg, ints_string] =
      jumble_string
      |> split_on_slashes(parts: 2)

    {arg, parse_ints(ints_string)}
  end

  defp parse_ints(ints_string) do
    ints_string
    |> split_on_slashes
    |> Enum.map(&String.to_integer/1)
  end

  defp parse_ints_w_string(ints_string) do
    fn(string, {ints, strings})->
      int =
        string
        |> String.to_integer

      {[int | ints], [string | strings]}
      |> Helper.wrap_prepend({int, string})
    end
    |> :lists.mapfoldr({[], []}, split_on_slashes(ints_string))
  end
####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp split_on_slashes(string, opts \\ []) do
    string
    |> String.split(~r{/}, opts)
  end
  
end