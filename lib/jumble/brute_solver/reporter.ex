defmodule Jumble.BruteSolver.Reporter do
  alias IO.ANSI
  alias Jumble.Helper

  @report_indent Helper.pad(4)
  @nl_and_indent "\n" <> @report_indent
  @default_color ANSI.white
  @color_size_tups Helper.color_size_tups(@default_color)
  # @max_size_length Application.get_env(:jumble, :scowl_dict_sizes)
  #   |> Enum.map(&byte_size/1)
  #   |> Enum.max

  @rankings_pads ~w(─   ─   ─)
  @rankings_join ~w(┬ │ ┼ │ ┴)
  @rankings_rcap ~w(┐ │ ┤ │ ┘)
    |> Enum.map(&(&1 <> "\n"))
  @rankings_lcap [
      "┌───────────────────────────",
      "│ word frequency percentile ",
      "├───────────────────────────",
      "│        valid picks        ",
      "└───────────────────────────"
    ]
    |> Enum.map(&(@report_indent <> &1))
    |> List.update_at(0, &Helper.cap("\n", @default_color, &1))

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
    |> Enum.reduce(@nl_and_indent, fn(line, report)->
      line
      |> Helper.cap(report, @nl_and_indent)
    end)
    |> Helper.cap(@default_color, "\n")
    |> IO.puts
  end

# ┼─  ┤ ├┌┐┘├└

  def report_rankings(ranked_picks, total_picks, time_elapsed) do
    ranked_picks
    |> Enum.reduce({@rankings_lcap, @color_size_tups}, fn({_dict_size, {_getters, _ids, count}}, {rows, [next_tup = {_next_color_size, next_str_len} | rem_tups]})->
      count_str =
        count
        |> Integer.to_string
      
      count_str_len =
        count_str
        |> byte_size

      col_width =
        count_str_len
        |> max(next_str_len)
        |> + 2

      pads =
        @rankings_pads
        |> Enum.map(&String.duplicate(&1, col_width))

      
      [{count_str, count_str_len}, next_tup]
      |> Enum.reduce(Enum.split(pads, 1), fn({str, str_len}, {cols, [pad | rem_pads]})->
        [pad | [Helper.split_pad_rem_cap(col_width - str_len, str) | cols]]
        |> Helper.wrap_append(rem_pads)
      end)
      |> elem(0)
      |> Enum.map_reduce({rows, @rankings_join}, fn(content, {[next_row | rem_rows], [next_join | rem_joins]})->
        next_join
        |> Helper.cap(next_row, content)
        |> Helper.wrap_append({rem_rows, rem_joins})
      end)
      |> elem(0)
      |> Helper.wrap_append(rem_tups)
    end)
    |> elem(0)
    |> Enum.reduce({"", @rankings_rcap}, fn(row, {table, [next_rcap | rem_rcaps]})->
      row
      |> Helper.cap(table, next_rcap)
      |> Helper.wrap_append(rem_rcaps)
    end)
    |> elem(0)
    |> IO.puts
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