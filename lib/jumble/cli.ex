defmodule Jumble.CLI do
  # @argv_test ["when the acupuncture worked the patient said it was/3/4/4", "nagld/2/4/5", "ramoj/3/4", "camble/1/2/4", "wraley/1/3/5"]
  # @argv_test ["what they had when they went the distance to shop in Chicago. I wish we could have shopped even longer. we shopped the perfect length./11/4/8/5"] ++ ~w(alnca/1/2/3/5 mgsea/1/2/3/4 tlhgif/1/2/3/6 vnaeue/2/3/4/6 naievt/1/2/4/6 trsotiu/4/5/7 sdeimwt/1/2/3/5/7)
  @argv_test ~w(clue/6/7 hnuck/1/2/3 turet/1/2/3 birsec/1/2/5/6 pajloy/1/4/6)
  # @argv_test ~w(clue/4/5 ylsyh/1/4 setgu/1/4 lasivu/1/3/5 nofdef/1/4)
  # @argv_test ~w(clue/9 tonji/2/5 zierp/1/3 babfly/1/2 rooman/3/4/5)
  # @argv_test ["how they described their work on the instruction book I'm starting the assembly chapter/6/5", "sobas/1/5", "galuh/1/2/3", "larmin/2/4/6", "ramaad/1/2/3"]
  # "how they described their work on the instruction book I'm starting the assembly chapter"/6/5 sobas/1/5 galuh/1/2/3 larmin/2/4/6 ramaad/1/2/3


  # ./jumble "you're beautiful.  would you model for me? Absolutely! I'd love to. when the artist asked to make a stone likeness of her, she said"/6/4 emaco/1/4 smurt/1/2/3 plitup/1/2/3 suhaqs/1/3
  # sculpt sure

  # @argv_test ["your usual norm? drinks for all my friends, sammy! tomorrow, I'm buying. the regulars at the insect pub were/3/5", "clofa/1/5", "cleri/1/4", "pibsoh/1/3", "gentam/2/5"]
  # ./jumble "your usual norm? drinks for all my friends, sammy! tomorrow, I'm buying. the regulars at the insect pub were"/3/5 clofa/1/5 cleri/1/4 pibsoh/1/3 gentam/2/5
  # bar flies (dict doesn't handle plural)

  # ./jumble "we are live from Kennedy Space Center. the Apollo 11 mission has just lifted off. I could watch shows about the moon all day. when they watched the Apollo 11 mission on TV, they watched a"/5/7 rayrm/1/2/4 esege/1/4/5 torpyh/2/3/4 cipaee/1/2/5
  # space program

  # ./jumble "to learn his rope tricks the magician had"/2/2/4 neyah/3/5 ttcar/1/5 lurbyr/1/3 utdogu/4/6
  # to be taut

  # ./jumble "chewie's biggest worry isn't stormtroopers or sith lords it's"/9 tabae/1/2/3 sahls/1/2 errdah/1/3 vidler/3/6
  # hairballs

  # ./jumble "what the starter said to my wife right before the couples piggyback race"/2/4/4 ragdu/2/3/4 osmeo/1/2/3 rulsye/3/6 nerlke/1/4
  # on your mark

  # ./jumble "would you like to hear our specials the only reason fido is allowed in a restaurant is because he is a"/7/3 sogeo/1/3/5 farcs/1/2/4 dulhed/4/6 vitace/4/5
  # service dog

  # ./jumble "see? as good as new. using tape to patch his favorite chair was this."/4/5 afect/4/5 volce/1/4 dinkly/1/6 yalern/3/4/6

  # ./jumble "when did you know that you wanted to be a quarterback? I've always known. He played qb in high school, college, and now the nfl because being a qb wasn't a"/7/5 mfiyl/1/2/5 nalgc/3/4/5 safcio/3/4/5 narpis/1/2/6

  # ./jumble "when the acupuncture worked the patient said it was/3/4/4" nagld/2/4/5 ramoj/3/4 camble/1/2/4 wraley/1/3/5
  # jab well done

  # ./jumble "don't worry, Stephan.  you're gonna win some and lose some. how could you forget my alibi?! A bad way for a lawyer to learn the criminal justice system."/5/5 laisa/2/3/4 laurr/1/3 bureek/1/2 prouot/3/5/6
  # trial error

  # ./jumble "what they had when they went the distance to shop in Chicago. I wish we could have shopped even longer. we shopped the perfect length."/11/4/8/5 alnca/1/2/3/5 mgsea/1/2/3/4 tlhgif/1/2/3/6 vnaeue/2/3/4/6 naievt/1/2/4/6 trsotiu/4/5/7 sdeimwt/1/2/3/5/7
  # rip CPU
  
  alias Jumble.ArgParser
  alias Jumble.StateBuilder
  # alias Jumble.LengthDict
  alias Jumble.ScowlDict
  alias Jumble.NLP
  alias Jumble.BruteSolver.PickTree
  alias Jumble.BruteSolver.Printer
  alias Jumble.BruteSolver
  alias Jumble.Unjumbler

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
    |> StateBuilder.build_state
    # |> LengthDict.start_link
    |> ScowlDict.start_link
    |> NLP.start_link
    |> PickTree.start_link
    |> BruteSolver.start_link
    |> Unjumbler.start_link
    |> Printer.start_link

    Jumble.process
  end
end