defmodule Jumble.BruteSolver.Reporter do
  alias IO.ANSI
  alias Jumble.Helper

  @report_indent   "\n" <> Helper.pad(4)
  @color_size_tups Helper.color_size_tups
  # @max_size_length Application.get_env(:jumble, :scowl_dict_sizes)
  #   |> Enum.map(&byte_size/1)
  #   |> Enum.max

  @rankings_pads ~w(─   ─   ─)
  @rankings_join ~w(┬ │ ┼ │ ┴)
  @rankings_lcap ~w(┌ │ ├ │ └)
    |> Enum.map(&(@report_indent <> &1))
  @rankings_rcap ~w(┐ │ ┤ │ ┘)
    |> Enum.map(&(&1 <> "\n"))

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

        @rankings_pads
        |> Enum.map(&String.duplicate(&1, col_width))

      
      @rankings_pads
      |> Enum.flat_map_reduce([next_tup, {count_str, count_str_len}, []], fn(pad, [{str, str_len} | rem_tups])->
        [String.duplicate(pad, col_width) | Helper.split_pad_rem_cap(col_width - str_len, str)]
        |> Helper.wrap_append(rem_tups)
      end)
      |> elem(0)
      |> Enum.map_reduce({rows, @rankings_join}, fn(content, {[next_row | rem_rows], [next_join | rem_joins]})->
        next_join
        |> Helper.cap(next_row, content)
        |> Helper.wrap_append({rem_rows, rem_joins})
      end)
      |> elem(0)
    end)
    |> Enum.reduce({"", @rankings_rcap}, fn(row, {table, [next_rcap | rem_rcaps]})->
      row
      |> Helper.cap(table, next_rcap)
      |> Helper.wrap_append(rem_rcaps)
    end)
    # |> elem(0)
    |> IO.inspect
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