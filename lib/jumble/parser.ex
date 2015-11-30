defmodule Jumble.Parser do
  alias Jumble.Parser.Stopwords
  alias Gibran.Tokeniser
  alias Gibran.Counter

  @stopwords Stopwords.get
  @reg_split_propers ~r/(?<lbound>\b)[A-Z]\w+(\s+[\d.]+)*(?<rbound>\b)/

  def parse(sentence) do
    {propers, impropers} =
      sentence
      |> parse_propers
      |> IO.inspect

    impropers
    |> Gibran.Tokeniser.tokenise(exclude: @stopwords)
    |> Enum.into(propers)
  end

  def parse_propers(sentence) do
    @reg_split_propers
    |> Regex.split(sentence, on: :all_names, trim: :true)
    |> IO.inspect
    |> partition_propers
  end

  def partition_propers(split_sentence = [head_token | _rest]) do
    split_sentence
    |> Enum.reduce({{[], ""}, head_token =~ ~r/^[A-Z]\w/}, fn
      (seg, {{propers, impropers}, true}) ->
        {{[seg | propers], impropers}, false}

      (seg, {{propers, impropers}, false}) ->
        {{propers, impropers <> seg}, true}
    end)
    |> elem(0)
  end
end