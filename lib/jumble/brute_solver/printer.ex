defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper

  @report_colors ANSI.white_background <> ANSI.black

  @header "BRUTE FORCE SOLUTIONS\n\n"
    |> Helper.cap(ANSI.underline, ANSI.no_underline)
    |> Helper.cap(ANSI.yellow, @report_colors)

  @unjumbleds_joiner        ANSI.black <> "or"

  @blank_lcap "║" <> ANSI.black_background
  @blank_rcap ANSI.white_background <> "║"

  @black_col ANSI.black <> "║"
  @header_joiners ["╦", @black_col, @black_col, "╬"]
  @header_caps   {["╔", "║",        @black_col, "╠"],
                  ["╗", @black_col, @black_col, "╣"]}

# ┼─  ┤ ├┌┐┘├└
# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬
#wewewe
# ══════

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  def start_link(%{sol_info: %{letter_bank_length: letter_bank_length, final_length: final_length}, jumble_info: %{unjumbleds_length: unjumbleds_length}}) do
    __MODULE__
    |> Agent.start_link(:init, [final_length, {letter_bank_length, unjumbleds_length}], name: __MODULE__)
  end

  def print_solutions(num_sol_groups, counts, sols) do
     __MODULE__
     |> Agent.get(& &1)
     |> print_solutions(num_sol_groups, counts, sols)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp print_solutions({total_content_rows, total_content_cols, col_width, lengths_tup, pads}, num_sol_groups, counts, sol_info) do
    allocated_dims =
      counts
      |> allocate_dims(total_content_cols - num_sol_groups, col_width)

    {header_info, content_info, bar_pads} =
       sol_info
       |> ordered_and_split_sol_info(lengths_tup, allocated_dims)

    table_header =
      header_info
      |> print_header(pads)
    
    content =
      content_info
      |> print_content(pads)

    bcap =
      bar_pads
      |> print_base(pads)

    table_header
    |> Helper.cap(@header, content <> bcap)
    |> IO.puts
  end

  def print_base(bar_pads, {lpad, rpad}) do
    bar_pads
    |> Enum.join("╩")
    |> Helper.cap("╚", "╝")
    |> Helper.cap(lpad, rpad)
  end

  def print_rows([next_col | rem_cols]) do
    rem_cols
    |> Enum.reduce(next_col, fn(col, acc_rows)->
      acc_rows
      |> Enum.map_reduce(col, fn(row, [next_cell | rem_cells])->
        "║"
        |> Helper.cap(row, next_cell)
        |> Helper.wrap_append(rem_cells)
      end)
      |> elem(0)
    end)
  end

  def print_content(content_info, {lpad, rpad}) do
    content_info
    |> print_rows
    |> Enum.map_join(fn(row)->
      row
      |> Helper.cap("║")
      |> Helper.cap(lpad, rpad)
    end)
  end

  def print_header([first_header_col | rem_header_cols], {lpad, rpad}) do
    rem_header_cols
    |> Enum.reduce(first_header_col, fn(header_col, header_lines)->
      header_col
      |> Enum.map_reduce({header_lines, @header_joiners}, fn(header_cell, {[line | rem_lines], [joiner | rem_joiners]})->
        joiner
        |> Helper.cap(line, header_cell)
        |> Helper.wrap_append({rem_lines, rem_joiners})
      end)
      |> elem(0)
    end)
    |> Enum.reduce({"", @header_caps}, fn(line, {header, {[lcap | rem_lcaps], [rcap | rem_rcaps]}})->
      next_line =
        line
        |> Helper.cap(lcap, rcap)
        |> Helper.cap(lpad, rpad)

      {header <> next_line, {rem_lcaps, rem_rcaps}}
    end)
    |> elem(0)
  end

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
  def split_pad_len_rem(rem_len, parts) do
    lpad_len = div(rem_len, parts)
    rpad_len = rem(rem_len, parts) + lpad_len

    {lpad_len, rpad_len}
  end

  def split_pad_rem(rem_len) do
    {lpad_len, rpad_len} =
      rem_len
      |> split_pad_len_rem(2)

    {Helper.pad(lpad_len), Helper.pad(rpad_len)}
  end

  def split_pad_rem_cap(rem_len, string) do
    {lpad, rpad} =
      rem_len
      |> split_pad_rem

    string
    |> Helper.cap(lpad, rpad)
  end

  def ordered_and_split_sol_info(sol_info, lengths_tup, allocated_dims) do
    allocated_dims
    |> Enum.reduce({[], [], []}, fn({index, cols_tup, rows_tup}, {header_info, content_info, bar_pads})->
      {next_header_info, next_content_info, next_bar_pad} =
        sol_info
        |> Enum.at(index)
        |> retreive_info(lengths_tup, cols_tup, rows_tup)

      {[next_header_info | header_info], [next_content_info | content_info], [next_bar_pad | bar_pads]}
    end)
  end

  def retreive_info({letter_bank, unjumbleds = [head_unjumbled | tail_unjumbleds], sols}, {letter_bank_length, unjumbleds_length}, {num_content_cols, colspan, content_col_width}, rows_tup) do
    letter_bank_string =
        colspan
        |> - letter_bank_length
        |> split_pad_rem_cap(letter_bank)
      
    num_unjumbleds =
      unjumbleds
      |> length

    header_cols = num_unjumbleds * (unjumbleds_length + 3) - 2

    total_header_pad_cols = colspan - header_cols

    {cols_per_unjumbled, next_cols_per_unjumbled} =
      total_header_pad_cols
      |> split_pad_len_rem(num_unjumbleds)

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
          @unjumbleds_joiner
          |> Helper.cap(unjumbleds_string, unjumbled_string)

        {next_unjumbles_string, next_cols, cols}
      end)
      |> elem(0)

    bar_pad =
      colspan
      |> Helper.pad("═")

    header_info = [bar_pad, unjumbleds_string, letter_bank_string, bar_pad]

    sol_strings =
      sols
      |> Enum.map(fn(sol_set)->
        sol_set
        |> Enum.reduce(" ", fn(sol, sol_string)->
          sol
          |> Helper.cap(sol_string, " ")
        end)
      end)

    content_info =
      rows_tup
      |> format_content(num_content_cols, sol_strings)

    {header_info, content_info, bar_pad}
  end

  def format_content({trailing_sols, trailing_blank_string, empty_rows}, num_content_cols, sol_strings) do
    {last_row_strings, rem_sol_strings} = 
      sol_strings
      |> Enum.split(trailing_sols)

    last_row =
      " "
      |> Helper.cap(Enum.join(last_row_strings, " "), trailing_blank_string)

    rem_sol_strings
    |> print_column(num_content_cols, [])
    |> Enum.concat([last_row | empty_rows])
  end

  def format_content({empty_rows}, num_content_cols, sol_strings) do
    sol_strings
    |> print_column(num_content_cols, [])
    |> Enum.concat(empty_rows)
  end

  def print_column([], _strings_per_col, finished_col), do: finished_col
  def print_column(strings, strings_per_col, acc_col)   do
    {next_strings, rem_strings} =
      strings
      |> Enum.split(strings_per_col)

    rem_strings
    |> print_column(strings_per_col, [Enum.join(next_strings, " ") | acc_col])
  end

  def allocate_dims(_counts, leftover_cols, col_width) when leftover_cols < 0, do: "not enough room!"

  def allocate_dims(%{total: total, indivs: indivs}, leftover_cols, col_width) do
    {indexed_indivs, {_last_index, next_leftover}} =
      indivs
      |> Enum.map_reduce({0, 0}, fn(count, {index, acc_trunc})->
        float = count * leftover_cols / total
        
        leftover_cols_allocated = trunc(float)

        trunc = float - leftover_cols_allocated

        num_content_cols = leftover_cols_allocated + 1

        colspan = num_content_cols * (col_width + 1) - 1

        {{trunc, index, num_content_cols, colspan, count}, {index + 1, acc_trunc + trunc}}
      end)

    {need_one_more, finalized} =
      indexed_indivs
      |> Enum.sort(&>=/2)
      |> Enum.split(round(next_leftover))

    allocations =
      [{_index, _cols_tup, max_rowspan_tup} | _rest_allocations] =
        need_one_more
        |> Enum.map(fn({trunc, index, num_content_cols, colspan, count})->
          {trunc, index, num_content_cols + 1, colspan + col_width + 1, count}
        end)
        |> Enum.concat(finalized)
        |> Enum.map(fn({_trunc, index, num_content_cols, colspan, count})->
          rows_tup = 
            num_content_cols
            |> rows_info(count)
            |> case do
              {rowspan, trailing_sols, trailing_blanks} ->
                trailing_blank_string =
                  trailing_blanks * (col_width + 1) - 1
                  |> Helper.pad
                  # |> Helper.cap(ANSI.black_background, ANSI.white_background)

                {rowspan, trailing_sols, trailing_blank_string}

              even_rows_tup -> even_rows_tup
            end

          {index, {num_content_cols, colspan, col_width}, rows_tup}
        end)
        |> Enum.sort_by(&(elem(&1, 2) |> elem(0)), &>=/2)

    allocations
    |> Enum.map(fn({index, cols_tup, rows_tup})->
      num_empty_rows =
        max_rowspan_tup
        |> elem(0)
        |> - elem(rows_tup, 0)

      blank_row = 
        cols_tup
        |> elem(1)
        |> Helper.pad

      empty_rows =
        blank_row
        |> List.duplicate(num_empty_rows)

      next_rows_tup =
        rows_tup
        |> Tuple.delete_at(0)
        |> Tuple.append(empty_rows)

      {index, cols_tup, next_rows_tup}
    end)
  end

  def rows_info(num_content_cols, count) do
    rem_sols =
      count
      |> rem(num_content_cols)

    full_rows =
      count
      |> div(num_content_cols)

    if rem_sols > 0 do
      {full_rows + 1, rem_sols, num_content_cols - rem_sols}
    else
      {full_rows}
    end
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