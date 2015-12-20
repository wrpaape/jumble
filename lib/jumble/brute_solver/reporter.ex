defmodule Jumble.BruteSolver.Reporter do
  alias IO.ANSI
  alias Jumble.Helper

  @report_indent Helper.pad(4)
  @nl_and_indent "\n" <> @report_indent
  @unique_picks_prefix @nl_and_indent <> "unique picks: "
  @time_elapsed_prefix @nl_and_indent <> "time elapsed: "
  @default_color ANSI.white
  @color_size_tups Helper.color_size_tups(@default_color)

  @rankings_join ~w(┬ │ ┼ │ ┴)
  @rankings_caps ~w(┌ │ ├ │ └)
    |> Enum.map(&(@nl_and_indent <> &1))
    |> Enum.zip(~w(┐ │ ┤ │ ┘))
  

  ##################################### external API #####################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def report_picks(num_uniqs, next_total, time_elapsed) do
    [num_uniqs, next_total]
    |> Enum.reduce({@unique_picks_prefix, ["/", " (picked/total)"]}, fn(int, {lcap, [rcap | rest]})->
      int
      |> Integer.to_string
      |> Helper.cap(lcap, rcap)
      |> Helper.wrap_append(rest)
    end)
    |> elem(0)
    |> print_with_time_elapsed(time_elapsed)
  end

  def report_rankings(ranked_picks, total_picks, time_elapsed) do
    ranked_picks
    |> Enum.reduce(initial_tups(total_picks), fn({_dict_size, {_getters, _ids, count}}, {rows, [next_tup | rem_tups]})->
      count
      |> Integer.to_string
      |> build_content_col(next_tup)
      |> Enum.map_reduce({rows, @rankings_join}, fn(content, {[next_row | rem_rows], [next_join | rem_joins]})->
        next_join
        |> Helper.cap(next_row, content)
        |> Helper.wrap_append({rem_rows, rem_joins})
      end)
      |> elem(0)
      |> Helper.wrap_append(rem_tups)
    end)
    |> elem(0)
    |> Enum.reduce({"", @rankings_caps}, fn(row, {table, [{lcap, rcap} | rem_caps]})->
      row
      |> Helper.cap(table <> lcap, rcap)
      |> Helper.wrap_append(rem_caps)
    end)
    |> elem(0)
    |> print_with_time_elapsed(time_elapsed)
  end
  
  # ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
  ##################################### external API #####################################


  ####################################### helpers ########################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def print_with_time_elapsed(report, time_elapsed) do
    [@default_color <> report, build_time_elapsed(time_elapsed)]
    |> Enum.reduce(&(&2 <> &1))
    # |> Helper.cap(, "\n")
    |> IO.write
  end

  def initial_tups(total_picks) do
    total_picks
    |> Integer.to_string
    |> Helper.cap("valid picks (", " total)")
    |> build_content_col({"word frequency percentile", 25})
    |> Helper.wrap_append(@color_size_tups)
  end

  def pads_tup(col_width) do
    ~w(─ ─ ─)
    |> Enum.map(&String.duplicate(&1, col_width))
    |> Enum.split(1)
  end

  def build_content_col(bot_str, top_tup = {_top_str, top_str_len}) do
    bot_str_len =
      bot_str
      |> byte_size

    col_width = 
      bot_str_len
      |> max(top_str_len)
      |> + 2

    [{bot_str, bot_str_len}, top_tup]
    |> Enum.reduce(pads_tup(col_width), fn({str, str_len}, {cols, [pad | rem_pads]})->
      [pad | [Helper.split_pad_rem_rjust(col_width - str_len, str) | cols]]
      |> Helper.wrap_append(rem_pads)
    end)
    |> elem(0)
  end

  def build_time_elapsed(micro_sec) do
    {time, units} =
      micro_sec
      |> time_with_units

    time
    |> Helper.cap(@time_elapsed_prefix, units)
  end

  defp time_with_units(micro_sec) when micro_sec < 1_000,     do: {Integer.to_string(micro_sec),        " μs"}
  defp time_with_units(micro_sec) when micro_sec < 1_000_000, do: {format_float(micro_sec / 1_000),     " ms"}
  defp time_with_units(micro_sec),                            do: {format_float(micro_sec / 1_000_000), " s" }

  defp  format_float(float) do
    :io_lib.format("~.4g", [float])
    |> hd
    |> List.to_string
  end
end