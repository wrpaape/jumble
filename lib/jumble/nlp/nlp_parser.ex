defmodule Jumble.NLP.NLPParser do
  alias Jumble.NLP.NLPParser.Stopwords
  alias Jumble.Helper

  @reg_bounds_propers ~r/(?<lbound>\b)[A-Z]\w+(\s+[\p{N}.]+)*(?<rbound>\b)/u
  @reg_tokens         ~r/[\p{L}'-]+/u
  @stopwords_pattern Stopwords.get
    |> Enum.map(&Helper.cap(&1, "/"))
    |> Enum.into(~w(/ , ; : . ? !))
    |> List.insert_at(0, " ")

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def tokenize(sentence) do
    {propers, impropers} =
      sentence
      |> parse_propers
      |> IO.inspect

    impropers
    |> filter_stopwords
    |> Enum.into(propers)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp filter_stopwords(impropers) do
    copmiled_pattern =
      @stopwords_pattern
      |> :binary.compile_pattern

    impropers
    |> String.downcase
    |> String.replace(@reg_tokens, "/\\0/")
    |> IO.inspect
    |> :binary.split(copmiled_pattern, [:global, :trim_all])
  end

  defp parse_propers(sentence) do
    @reg_bounds_propers
    |> Regex.split(sentence, on: :all_names, trim: true)
    |> partition_propers
  end

  defp partition_propers(split_sentence = [head_token | _rest]) do
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