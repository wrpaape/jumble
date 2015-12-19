defmodule Jumble.BruteSolver.Reporter do
  alias IO.ANSI
  alias Jumble.Helper

  @report_indent "\n" <> Helper.pad(4)

  ##################################### external API #####################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def report_picks(next_total, num_uniqs, time_elapsed) do
    sols_counts =
      [num_uniqs, next_total]
      |> Enum.reduce({"unique picks: ", ["/", " (picked/total)"]}, fn(int, {lcap, [rcap | rest]})->
        int
        |> Integer.to_string
        |> Helper.cap(lcap, rcap)
        |> Helper.wrap_append(rest)
      end)
      |> elem(0)
    
    [sols_counts, build_time_elapsed(time_elapsed)]
    |> Enum.reduce(@report_indent, fn(line, report)->
      line
      |> Helper.cap(report, @report_indent)
    end)
    |> Helper.cap(ANSI.white, "\n")
    |> IO.puts
  end

  def report_rankings(ranked_picks, num_picks, time_elapsed) do

  end
  
  # ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
  ##################################### external API #####################################



  ####################################### helpers ########################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp build_time_elapsed(micro_sec) do
    {time, units} =
      micro_sec
      |> time_with_units

    time
    |> Integer.to_string
    |> Helper.cap("time elapsed: ", units)
  end

  defp time_with_units(micro_sec) when micro_sec < 1_000,     do: {micro_sec,                    " μs"}
  defp time_with_units(micro_sec) when micro_sec < 1_000_000, do: {round(micro_sec / 1_000),     " ms"}
  defp time_with_units(micro_sec),                            do: {round(micro_sec / 1_000_000), " s" }
end