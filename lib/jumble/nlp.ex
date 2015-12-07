defmodule Jumble.NLP do
  alias IO.ANSI
  alias Jumble.Helper
  alias Jumble.NLP.NLPParser

  @tokens_spacer "\n\nCLUE TOKENS"
    |> Helper.cap(ANSI.underline, ANSI.no_underline)
    |> Helper.cap(ANSI.blue, ANSI.cyan)

  def start_link(args = %{sol_info: %{clue: clue}}) do
    NLPParser
    |> Agent.start_link(:tokenize, [clue], name: __MODULE__)

    args
  end

  def report_tokens do
    __MODULE__
    |> Agent.get(& &1)
    |> Enum.join("\n  - ")
    |> Helper.cap("\n")
    |> IO.puts
  end

  # def process(clue) do
  #   clue
  #   |> IO.inspect
  # end
end