defmodule Jumble.Unjumbler do
  alias Jumble.Helper
  alias Jumble.BruteSolver
  alias Jumble.LengthDict
  alias IO.ANSI

  @jumble_spacer       "\n\n" <> ANSI.magenta
  @unjumbled_spacer    "\n  " <> ANSI.yellow
  @cc_spacer             ". " <> ANSI.red
  @key_spacer ANSI.blink_slow <> ANSI.green
  @rem_spacer ANSI.blink_off  <> ANSI.red
  @header "JUMBLES\n\n"
    |> Helper.cap(ANSI.underline, ANSI.no_underline) 
    |> Helper.cap(ANSI.blue, ANSI.magenta)

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(%{jumble_info: %{jumble_maps: jumble_maps}}) do
    Agent.start_link(fn -> jumble_maps end, name: __MODULE__)
  end

  def process do
    __MODULE__
    |> Agent.get(& &1)
    |> unjumble
    |> Helper.cap(@header, "\n\n")
    |> IO.puts
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp unjumble(jumble_maps) do
    jumble_maps
    |> Enum.map_join(@jumble_spacer, fn({jumble, %{jumble_index: jumble_index, length: length, string_id: string_id, keys_at: keys_at}}) ->
      reg_match_keys =
        length
        |> reg_key_letters(keys_at)

      unjumbled_rows =
        length
        |> LengthDict.get(string_id)
        |> Helper.with_index(1)
        |> Enum.map_join(@unjumbled_spacer, fn({unjumbled, index}) ->
          jumble
          |> unjumbled_row(unjumbled, index, reg_match_keys)
        end)

      @unjumbled_spacer
      |> Helper.cap(jumble, unjumbled_rows)
      |> number_string(jumble_index, ". ")
    end)
  end

  defp unjumbled_row(jumble, unjumbled, unjumbled_index, reg_match_keys) do
    key_letters =
      reg_match_keys
      |> Regex.run(unjumbled, capture: :all_but_first)

    jumble
    |> BruteSolver.push_unjumbled(unjumbled, key_letters)

    reg_match_keys
    |> Regex.split(unjumbled, on: :all_but_first)
    |> color_code(key_letters)
    |> number_string(unjumbled_index, @cc_spacer)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp color_code([excess_head | excess_rest], key_letters) do
    key_letters
    |> Enum.zip(excess_rest)
    |> Enum.reduce(excess_head, fn({key, excess}, acc) ->
      key
      |> Helper.cap(@key_spacer, @rem_spacer)
      |> Helper.cap(acc, excess)
    end)
  end

  defp reg_key_letters(length, keys_at) do
    raw = 
      1..length
      |> Enum.map_join(fn(index) ->
        if index in keys_at, do: "(\\w)", else: "\\w"
      end)
    
    ~r/[^()]{4,}/
    |> Regex.replace(raw, fn(ws) ->
      ws
      |> byte_size
      |> div(2)
      |> Integer.to_string
      |> Helper.cap("\\w{", "}")
    end)
    |> Regex.compile!
  end

  defp number_string(string, index_string, spacer) do
    Integer.to_string(index_string)
    <> spacer
    <> string
  end
end