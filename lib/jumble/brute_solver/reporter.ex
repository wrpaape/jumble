defmodule Jumble.BruteSolver.Reporter do
  alias IO.ANSI
  alias Jumble.Helper

  @report_indent   "\n" <> Helper.pad(4)
  @colorized_sizes Helper.colorized_sizes
  # @max_size_length Application.get_env(:jumble, :scowl_dict_sizes)
  #   |> Enum.map(&byte_size/1)
  #   |> Enum.max

  @rankings_rcap ~w(┐ │ ┤ │ ┘)
  @rankings_lcap ~w(┌ │ ├ │ └)
    |> Enum.map(&(@report_indent <> &1))

  ##################################### external API #####################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def report_picks(num_uniqs, next_total, time_elapsed) do
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

# ┼─  ┤ ├┌┐┘├└

  def report_rankings(ranked_picks, total_picks, time_elapsed) do
    ranked_picks
    |> Enum.reduce({@rankings_lcap, @colorized_sizes}, fn({dict_size, {_getters, _ids, count}}, {lcap, [next_color_size | rem_color_sizes]})->
      count_str =
        count
        |> Integer.to_string


    end)
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