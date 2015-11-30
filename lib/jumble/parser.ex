defmodule Parser do
  alias Jumble.Parser.Stopwords
  alias Gibran.Tokeniser
  alias Gibran.Counter

  @stopwords Stopwords.get

  def parse(sentence) do
    {propers, impropers} =
      sentence
      |> parse_propers

    Tokeniser.tokenise
  end

  def parse_propers(sentence) do
        ~r/(\b)[A-Z]\w+(\b)/
        |> Regex.split(sentence, on: :all_but_first, trim: :true)
        |> partition_propers

      if head_token =~ ~r/[A-Z]/ do
        impropers =
          tail_tokens
          |> Enum.take_every(2)
        propers =
          split_sentence
          |> Enum.take_every(2)
      else

      end


  end

  def partition_propers(split_sentence = [head_token | _rest]) do


  end
end