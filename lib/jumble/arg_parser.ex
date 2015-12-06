defmodule Jumble.ArgParser do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  alias Jumble.Helper
  alias Jumble.Stats

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

        {jumble_maps, uniq_jumble_lengths} =
          jumble_strings
          |> Helper.with_index(1)
          |> Enum.map_reduce(HashSet.new, fn({jumble_string, index}, uniq_jumble_lengths) ->
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

            {{jumble, jumble_map}, Set.put(uniq_jumble_lengths, length_jumble)} 
          end)

        jumble_info =
          Map.new
          |> Map.put(:jumble_maps, jumble_maps)
          |> Map.put(:uniq_lengths, uniq_jumble_lengths)

        Map.new        
        |> Map.put(:sol_info, sol_info)
        |> Map.put(:jumble_info, jumble_info)
    end
  end


  def parse_arg_strings([clue, sol_lengths_string]) do
    sol_lengths =
      parse_ints(sol_lengths_string)

    {uniq_sol_lengths, dup_tail} =
      sol_lengths
      |> Helper.with_index(1, :leading)
      |> Helper.partition_dups_by_val

    pick_orders =
      uniq_sol_lengths
      |> Stats.uniq_pick_orders(dup_tail)

    uniq_lengths =
      uniq_sol_lengths
      |> Keyword.values
      |> Enum.into(HashSet.new)

    brute_map =
      Map.new
      |> Map.put(:total, 0)
      |> Map.put(:sols, [])

    Map.new
    |> Map.put(:clue, clue)
    |> Map.put(:sol_lengths, sol_lengths)
    |> Map.put(:uniq_lengths, uniq_lengths)
    |> Map.put(:pick_orders, pick_orders)
    |> Map.put(:invalid_ids, HashSet.new)
    |> Map.put(:processed_raw, HashSet.new)
    |> Map.put(:brute, brute_map)
  end

  def parse_arg_strings(jumble_string) do
    [arg, ints_string] =
      jumble_string
      |> split_on_slashes(parts: 2)

    {arg, parse_ints(ints_string)}
  end

  def parse_ints(ints_string) do
    ints_string
    |> split_on_slashes
    |> Enum.map(&String.to_integer/1)
  end

  def split_on_slashes(string, opts \\ []) do
    string
    |> String.split(~r{/}, opts)
  end
end