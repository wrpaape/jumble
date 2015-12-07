defmodule Jumble.NLP do
  alias IO.ANSI
  alias Jumble.Helper
  alias Jumble.NLP.NLPParser

  @header "CLUE TOKENS\n"
    |> Helper.cap(ANSI.underline, ANSI.no_underline)
    |> Helper.cap(ANSI.blue, ANSI.cyan)

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args = %{sol_info: %{clue: clue}}) do
    NLPParser
    |> Agent.start_link(:tokenize, [clue], name: __MODULE__)

    args
  end

  def report_tokens do
    __MODULE__
    |> Agent.get(& &1)
    |> Enum.reduce(@header, fn(token, list)->
      "\n  - "
      |> Helper.cap(list, token)
    end)
    |> Helper.cap(ANSI.clear, "\n\n")
    |> IO.puts
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################
end