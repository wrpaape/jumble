defmodule Jumble do
  alias IO.ANSI
  alias Jumble.Unjumbler
  alias Jumble.BruteSolver
  alias Jumble.Helper

  @header    ANSI.underline <> ANSI.blue <> "JUMBLES:\n" <> ANSI.no_underline <> ANSI.white
  @clue_sol_spacer "\n    " <> ANSI.cyan


  def start_link(%{jumble_info: %{jumble_maps: jumble_maps}}) do
    Agent.start_link(fn -> jumble_maps end, name: __MODULE__)
  end

  def start_solving do
    __MODULE__
    |> Agent.get_and_update(fn(jumble_maps) ->
      {jumble_maps, Map.new}
    end)
    |> Unjumbler.unjumble
    |> Helper.cap(@header, "\n\n")
    |> IO.puts

    BruteSolver
  end

  def report_and_record(unjumbled_sol, next_results) do
    next_results
    |> length
    |> Integer.to_string
    |> Helper.cap(@clue_sol_spacer, " unique running solutions\n")
    |> IO.puts

    __MODULE__
    |> Agent.update(fn(all_results)->
      all_results
      |> Map.put(unjumbled_sol, next_results)
    end)
  end
end