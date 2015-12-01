defmodule Jumble.CLI do
  @parse_opts [switches: [ help: :boolean],
               aliases:  [ h:    :help   ]]

  @argv_test ["when the acupuncture worked the patient said it was/3/4/4", "nagld/2/4/5", "ramoj/3/4", "camble/1/2/4", "wraley/1/3/5"]

  alias Jumble.Helper
  alias Jumble.Solver
  alias Jumble.LengthDict

  # def main(argv) do
    # argv
  def main(argv \\ @argv_test) do
    # ~w(when/the/acupuncture/worked/the/patient/said/it/was?3/4/4 nagld/2/4/5 ramoj/3/4 camble/1/2/4 wraley/1/3/5)
    # job well done
    # ~w(clue?9 tonji/2/5 zierp/1/3 babfly/1/2 rooman/3/4/5)
    # portfolio
    # ~w(clue?4/5 ylsyh/1/4 setgu/1/4 lasivu/1/3/5 nofdef/1/4)
    # loss vegas
    # ~w(clue?6/7 hnuck/1/2/3 turet/1/2/3 birsec/1/2/5/6 pajloy/1/4/6)
    # touchy subject
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
        {clue, final_lengths} =
          clue_string
          |> split_on_slashes(parts: 2)
          |> parse_arg_strings

        jumble_maps =
          jumble_strings
          |> Helper.with_index(1)
          |> Enum.map(fn({jumble_string, index}) ->
            {jumble, keys_at} =
              jumble_string
              |> parse_arg_strings

            jumble_map =
              Map.new
              |> Map.put_new(:jumble_index, index)
              |> Map.put_new(:length, byte_size(jumble))
              |> Map.put_new(:string_id, Helper.string_id(jumble))
              |> Map.put_new(:keys_at, keys_at)
              |> Map.put_new(:unjumbleds, [])

            {jumble, jumble_map}
          end)
        
        Map.new        
        |> Map.put_new(:clue, clue)
        |> Map.put_new(:final_lengths, final_lengths)
        |> Map.put_new(:jumble_maps, jumble_maps)
    end
  end

  def split_on_slashes(string, opts \\ []) do
    string
    |> String.split(~r{/}, opts)
  end

  def parse_arg_strings([message_string, final_lengths_string]) do
    {split_on_slashes(message_string), parse_ints(final_lengths_string)}
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