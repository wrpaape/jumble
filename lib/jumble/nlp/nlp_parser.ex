defmodule Jumble.NLP.NLPParser do
  alias Jumble.NLP.NLPParser.Stopwords
  alias Jumble.Helper

  @reg_split_propers ~r/(?<lbound>\b)[A-Z]\w+(\s+[\d.]+)*(?<rbound>\b)/
  @stopwords_pattern Stopwords.get
  |> Enum.map(&Helper.cap(&1, "/"))
  |> Enum.into([" ", "/"])

  def tokenize(sentence) do
    {propers, impropers} =
      sentence
      |> parse_propers

    impropers
    |> filter_stopwords
    |> Enum.into(propers)
  end

  def filter_stopwords(impropers) do
    copmiled_pattern =
      @stopwords_pattern
      |> :binary.compile_pattern

    impropers
    |> String.downcase
    |> String.replace(~r/\b/, "/")
    |> :binary.split(copmiled_pattern, [:global, :trim_all])
  end

  def parse_propers(sentence) do
    @reg_split_propers
    |> Regex.split(sentence, on: :all_names, trim: true)
    |> IO.inspect
    |> partition_propers
  end

  def partition_propers(split_sentence = [head_token | _rest]) do
    split_sentence
    |> Enum.reduce({{[], ""}, head_token =~ ~r/^[A-Z]\w/}, fn
      (next_proper, {{propers, impropers}, true}) ->
        {{[next_proper | propers], impropers}, false}

      (improper_seg, {{propers, impropers}, false}) ->
        {{propers, impropers <> improper_seg}, true}
    end)
    |> elem(0)
  end
end