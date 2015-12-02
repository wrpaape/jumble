defmodule Jumble.CLI do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  @argv_test ["when the acupuncture worked the patient said it was/3/4/4", "nagld/2/4/5", "ramoj/3/4", "camble/1/2/4", "wraley/1/3/5"]

  alias Jumble.Helper
  alias Jumble.Stats
  alias Jumble.Solver
  alias Jumble.LengthDict

    # ~w(when/the/acupuncture/worked/the/patient/said/it/was?3/4/4 nagld/2/4/5 ramoj/3/4 camble/1/2/4 wraley/1/3/5)
    # job well done
    # ~w(clue?9 tonji/2/5 zierp/1/3 babfly/1/2 rooman/3/4/5)
    # portfolio
    # ~w(clue?4/5 ylsyh/1/4 setgu/1/4 lasivu/1/3/5 nofdef/1/4)
    # loss vegas
    # ~w(clue?6/7 hnuck/1/2/3 turet/1/2/3 birsec/1/2/5/6 pajloy/1/4/6)
    # touchy subject
    
  def main(argv \\ @argv_test) do
    argv
    |> parse_args
    |> process
  end

  def process(:help) do
    """
    usage: jumble <final> <jumble0> <jumble1> ... <jumbleN>
    """
    |> IO.puts

    System.halt(0)
  end

  def process(args) do
    args
    |> LengthDict.start_link
    |> Solver.start_link
    |> Jumble.start
  end

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

  def split_on_slashes(string, opts \\ []) do
    string
    |> String.split(~r{/}, opts)
  end

  def parse_arg_strings([message_string, sol_lengths_string]) do
    clue =
      message_string
      |> split_on_slashes

    sol_lengths =
      parse_ints(sol_lengths_string)

    ordered_sol_lengths =
      sol_lengths
      |> Helper.with_index(1, :leading)
      |> Enum.into(Map.new)

    {uniq_sol_lengths, dup_tail} =
      sol_lengths
      |> Helper.partition_dups


    # uniq_pick_orders =
    #   uniq_sol_lengths
    #   |> Helper.with_counter(1)
    #   |> Stats.combinations
    #   |> Enum.sort
    #   |> Enum.reduce(Map.new, fn([pick_index, uniq_pick_length], pick_map)->
    #     pick_map
    #     |> Map.update(pick_index, [uniq_pick_length], fn(acc_pick_lengths)->
    #       [uniq_pick_length | acc_pick_lengths]
    #     end)
    #   end)
    #   |> IO.inspect
    #   |> Enum.reduce(fn({_pick_index, uniq_starts})->
    #     uniq_starts ++ dup_tail
    #   end)
    #   |> IO.inspect



    Map.new
    |> Map.put(:clue, clue)
    |> Map.put(:uniq_lengths, Enum.into(uniq_sol_lengths, HashSet.new))
    # |> Map.put(:uniq_pick_orders, uniq_pick_orders)
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
end