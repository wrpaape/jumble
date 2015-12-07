defmodule Jumble.CLI do
  @argv_test ["when the acupuncture worked the patient said it was/3/4/4", "nagld/2/4/5", "ramoj/3/4", "camble/1/2/4", "wraley/1/3/5"]
  # @argv_test ~w(clue/6/7 hnuck/1/2/3 turet/1/2/3 birsec/1/2/5/6 pajloy/1/4/6)
  # @argv_test ~w(clue/4/5 ylsyh/1/4 setgu/1/4 lasivu/1/3/5 nofdef/1/4)
  # @argv_test ~w(clue/9 tonji/2/5 zierp/1/3 babfly/1/2 rooman/3/4/5)

  alias Jumble.ArgParser
  alias Jumble.LengthDict
  alias Jumble.NLP
  alias Jumble.PickTree
  alias Jumble.BruteSolver
  alias Jumble.Unjumbler

    # ~w("when the acupuncture worked the patient said it was/3/4/4" nagld/2/4/5 ramoj/3/4 camble/1/2/4 wraley/1/3/5)
    # job well done
    # ~w(clue/9 tonji/2/5 zierp/1/3 babfly/1/2 rooman/3/4/5)
    # portfolio
    # ~w(clue/4/5 ylsyh/1/4 setgu/1/4 lasivu/1/3/5 nofdef/1/4)
    # loss vegas
    # ~w(clue/6/7 hnuck/1/2/3 turet/1/2/3 birsec/1/2/5/6 pajloy/1/4/6)
    # touchy subject
    
  def main(argv \\ @argv_test) do
    argv
    |> ArgParser.parse_args
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
    |> NLP.start_link
    |> PickTree.start_link
    |> BruteSolver.start_link
    |> Unjumbler.start_link

    Jumble.process
  end
end