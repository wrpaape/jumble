defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper

  @report_colors ANSI.white_background <> ANSI.black
  @unjumbleds_join          ANSI.black <> " or "
  @cap_pieces [
    {"╔", "╦", "╗"},
    {"╚", "╩", "╝"}
  ]

  @header_joins ["╦", "╬", "╬", "╩"]
  @header_lcaps ["╔", "║", "║", "╠"]
  @header_rcaps ["╗", "║", "║", "╣"]

# ┼─  ┤ ├┌┐┘├└
# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬
#wewewe
# ══════

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  def start_link(%{sol_info: %{letter_bank_length: letter_bank_length, final_length: final_length}, jumble_info: %{unjumbleds_length: unjumbleds_length}}) do
    __MODULE__
    |> Agent.start_link(:init, [final_length + 2, {letter_bank_length, unjumbleds_length}], name: __MODULE__)
  end

  def print_solutions(num_sol_groups, counts, sols) do
     __MODULE__
     |> Agent.get(& &1)
     |> print_solutions(num_sol_groups, counts, sols)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp print_solutions({total_content_rows, total_content_cols, col_width, lengths_tup, pads}, num_sol_groups, counts, sol_info) do
    # IO.inspect [{total_content_rows, total_content_cols, col_width, pads}, num_sol_groups, counts, sol_info]
    allocated_cols =
      counts
      |> allocate_cols(total_content_cols - num_sol_groups, col_width)

    {header_info, content_info} =
       sol_info
       |> ordered_and_split_sol_info(col_width, lengths_tup, allocated_cols)

    header =
      header_info
      |> print_header(pads)
      |> IO.puts

    # content =
    #   content_info
    #   |> print_content(total_content_rows, pads)
  end

# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬

  def print_header(header_info, {lpad, rpad}) do
    {tcap, unjumbleds, letter_banks, bcaps} =
      header_info
      |> Enum.unzip
      |> Tuple.to_list
      |> Enum.zip({@header_lcaps, @header_joins, @header_r})
      |> Enum.map_join(fn(lines)->
        lines
        |> Enum.map_join
      end)
  end
  # def print_header(header_info = [header_head | header_tail], {lpad, rpad}) do
    # tcap, header_line, letter_bank_line, bcap =
      # header_info
      # |> Enum.reduce(["", "", "", ""], fn({header_string, letter_bank_string, bar_pad}, lines)->
      #   strings =
      #     [bar_pad, header_string, letter_bank_string, bar_pad]

      #   lines
      #   |> Enum.map_reduce({@header_joins, strings}, fn(line, {[join | rem_joins], [string | rem_strings]})->
      #     join
      #     |> Helper.cap(string, line)
      #     |> Helper.wrap_append({rem_joins, rem_strings})
      #   end)
      #   |> elem(0)
      # end)
      # |> Enum.reduce({"", @header_lcaps, @header_rcaps}, fn(line, {header, [lcap | rem_lcaps], [rcap | rem_rcaps]})->
      #   next_line =
      #     line
      #     |> Helper.cap(lcap, rcap)
      #     |> Helper.cap(lpad, rpad)

      #   {header <> next_line, rem_lcaps, rem_rcaps}
      # end)
      # |> elem(0)


      # |> Enum.map_join("╦", &Helper.pad(elem(&1, 1) * (col_width + 1) - 1, "═"))
      # |> Helper.cap("╔", "╗")
      # |> Helper.cap(@report_colors <> lpad, rpad)
  # end

  # def print_content(sol_info, total_content_rows, pads) do
      


  # end

  def init(content_col_width, lengths_tup) do
    [rows, cols] = get_dims

    total_content_cols =
      cols
      |> max_num_content_cols(content_col_width)

    content_cols_with_pad_and_borders = total_content_cols * (content_col_width + 1) + 1
    
    pads =
      cols
      |> - content_cols_with_pad_and_borders
      |> split_pad_rem

    {rows - 5, total_content_cols, content_col_width, lengths_tup, pads}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def split_pad_rem(rem_len) do
    lpad_len = div(rem_len, 2)
    rpad_len = rem(rem_len, 2) + lpad_len

    {Helper.pad(lpad_len), Helper.pad(rpad_len)}
  end

  def split_pad_rem_cap(rem_len, string) do
    {lpad, rpad} =
      rem_len
      |> split_pad_rem

    string
    |> Helper.cap(lpad, rpad)
  end

  def ordered_and_split_sol_info(sol_info, content_col_width, lengths_tup, allocated_cols) do
    allocated_cols
    |> Enum.reduce({[], []}, fn({index, num_content_cols, num_cols}, {header_info, content_info})->
      {next_header_info, next_content_info} =
        sol_info
        |> Enum.at(index)
        |> retreive_info(lengths_tup, num_content_cols, content_col_width, num_cols)

      {[next_header_info | header_info], [next_content_info | content_info]}
    end)
  end

  def retreive_info({letter_bank, unjumbleds = [head_unjumbled | tail_unjumbleds], sols}, {letter_bank_length, unjumbleds_length}, num_content_cols, content_col_width, num_cols) do
    letter_bank_string =
        num_cols
        |> - letter_bank_length
        |> split_pad_rem_cap(letter_bank)
      
      num_unjumbleds =
        unjumbleds
        |> length

      header_cols = num_unjumbleds * (unjumbleds_length + 3) - 3

      total_header_pad_cols = num_cols - header_cols

      cols_per_unjumbled      = div(total_header_pad_cols, num_unjumbleds)
      next_cols_per_unjumbled = rem(total_header_pad_cols, num_unjumbleds) + cols_per_unjumbled

      head_seg =
        cols_per_unjumbled
        |> split_pad_rem_cap(head_unjumbled)

      unjumbleds_string =
        tail_unjumbleds
        |> Enum.reduce({head_seg, next_cols_per_unjumbled, cols_per_unjumbled}, fn(unjumbled, {unjumbleds_string, cols, next_cols})->
          unjumbled_string =
            cols
            |> split_pad_rem_cap(unjumbled)

          next_unjumbles_string =
            @unjumbleds_join
            |> Helper.cap(unjumbleds_string, unjumbled_string)

          {next_unjumbles_string, next_cols, cols}
        end)
        |> elem(0)

      bar_pad =
        num_cols
        |> Helper.pad("═")

      [bar_pad, unjumbleds_string, letter_bank_string, bar_pad]
      |> Helper.wrap_append({sols, split_pad_rem(content_col_width)})
  end

  def allocate_cols(_counts, leftover_cols, col_width) when leftover_cols < 0, do: "not enough room!"

  def allocate_cols(%{total: total, indivs: indivs}, leftover_cols, col_width) do
    {indexed_indivs, {_last_index, next_leftover}} =
      indivs
      |> Enum.map_reduce({0, 0}, fn(count, {index, acc_trunc})->
        float = count * leftover_cols / total
        leftover_cols_allocated = trunc(float)

        trunc = float - leftover_cols_allocated

        num_content_cols = leftover_cols_allocated + 1

        colspan = num_content_cols * (col_width + 1) - 1

        {{trunc, index, num_content_cols, colspan}, {index + 1, acc_trunc + trunc}}
      end)

    {need_one_more, finalized} =
      indexed_indivs
      |> Enum.sort(&>=/2)
      |> Enum.split(round(next_leftover))

    need_one_more
    |> Enum.map(fn({trunc, index, num_content_cols, colspan})->
      {trunc, index, num_content_cols + 1, colspan + col_width + 1}
    end)
    |> Enum.concat(finalized)
    |> Enum.map(&Tuple.delete_at(&1, 0))
    # |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.sort_by(&elem(&1, 1))
  end

  defp get_dims do
    [:rows, :columns]
    |> Enum.map(fn(dim_fun)->
      :io
      |> apply(dim_fun, [])
      |> elem(1)
    end)
  end

  defp max_num_content_cols(all_cols, col_width) do
    max_content_cols = all_cols - 2

    max_content_cols
    |> div(col_width)
    |> adjust(rem(max_content_cols, col_width))
  end

  defp adjust(max_num_content_cols, leftover_content) do
    max_num_content_cols
    |> + if leftover_content > max_num_content_cols, do: 0, else: -1
  end 
end