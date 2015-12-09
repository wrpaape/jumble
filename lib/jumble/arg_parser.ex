defmodule Jumble.ArgParser do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  alias Jumble.Helper
  alias Jumble.Helper.Stats

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def parse_args(argv) do
    argv
    |> OptionParser.parse(@parse_opts)
    |> case do
      {[help: true], _, _ } -> :help
      
      {_, [], _}            -> :help

      {_, [_ | []], _}      -> :help
      
      {_, [clue_string | jumble_strings], _} ->
        sol_info =
          clue_string
          |> split_on_slashes(parts: 2)
          |> parse_arg_strings

        {jumble_maps, {uniq_jumble_lengths, unjumbleds_length}} =
          jumble_strings
          |> Helper.with_index(1)
          |> Enum.map_reduce({HashSet.new, -1}, fn({jumble_string, index}, {uniq_jumble_lengths, unjumbleds_length}) ->
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

            {{jumble, jumble_map}, {Set.put(uniq_jumble_lengths, length_jumble), unjumbleds_length + length_jumble + 1}} 
          end)

        jumble_info =
          Map.new
          |> Map.put(:jumble_maps, jumble_maps)
          |> Map.put(:uniq_lengths, uniq_jumble_lengths)
          |> Map.put(:unjumbleds_length, unjumbleds_length)

        Map.new        
        |> Map.put(:sol_info, sol_info)
        |> Map.put(:jumble_info, jumble_info)
    end
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp parse_arg_strings([clue, sol_lengths_string]) do
    sol_lengths =
      [first_sol_length | rem_sol_lengths] =
        sol_lengths_string
        |> parse_ints

    {letter_bank_length, final_sol_length} =
      rem_sol_lengths
      |> Enum.reduce({first_sol_length * 2 + 3, first_sol_length}, fn(sol_length, {letter_bank_length, final_sol_length})->
        {letter_bank_length + sol_length * 2, final_sol_length + sol_length + 1}
      end)

    {uniq_sol_lengths, dup_tail} =
      sol_lengths
      |> Helper.with_index(1, :leading)
      |> partition_dups_by_val

    pick_orders =
      uniq_sol_lengths
      |> Stats.uniq_pick_orders(dup_tail)

    uniq_lengths =
      uniq_sol_lengths
      |> Keyword.values
      |> Enum.into(HashSet.new)

    counts_map =
      Map.new
      |> Map.put(:total, 0)
      |> Map.put(:indivs, [])
      |> Map.put(:sol_groups, 0)

    brute_map =
      Map.new
      |> Map.put(:counts, counts_map)
      |> Map.put(:sols, [])

    Map.new
    |> Map.put(:clue, clue)
    |> Map.put(:letter_bank_length, letter_bank_length)
    |> Map.put(:final_length, final_sol_length + 3)
    |> Map.put(:sol_lengths, sol_lengths)
    |> Map.put(:uniq_lengths, uniq_lengths)
    |> Map.put(:pick_orders, pick_orders)
    |> Map.put(:invalid_ids, HashSet.new)
    |> Map.put(:processed_raw, HashSet.new)
    |> Map.put(:brute, brute_map)
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

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp partition_dups_by_val(keyword) do
    keyword
    |> Enum.reduce({[], [], HashSet.new}, fn(el = {_key, val}, {uniqs, dups, uniq_vals})->
      if Set.member?(uniq_vals, val) do
        {uniqs, [el | dups], uniq_vals}
      else
        {[el | uniqs], dups, Set.put(uniq_vals, val)}
      end
    end)
    |> Tuple.delete_at(2)
  end

  defp split_on_slashes(string, opts \\ []) do
    string
    |> String.split(~r{/}, opts)
  end
end