defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper

  @report_colors ANSI.white_background <> ANSI.black
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
    # IO.inspect [{total_content_rows, total_content_cols, col_width, pads}, num_sol_groups, counts, sol_info]
    allocated_dims =
      counts
      |> allocate_dims(total_content_cols - num_sol_groups, col_width)

    {header_info, content_info} =
       sol_info
       |> ordered_and_split_sol_info(col_width, lengths_tup, allocated_dims)

    header =
      header_info
      |> print_header(pads)
    
    # IO.puts @report_colors <> header

    content =
      content_info
      |> print_content(pads)
  end

# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬

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

  # def print_content(content_info, {lpad, rpad}) do
  #   content_info
  #   |> print_rows
  #   |> Enum.reduce({[], []},fn({sols, content_cols}, {acc_row, rem_sols})->
  #     {row_strings, rem_sols} =
  #       sols
  #       |> Enum.split(content_cols)

  #     row_strings
  #     |> Enum.join(" ")

  #   end)
  #   |> IO.inspect
  #   # IO.inspect content_info

  #   # content_info
  #   # |> Enum.map(fn({sols, }))
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

  def ordered_and_split_sol_info(sol_info, content_col_width, lengths_tup, allocated_dims) do
    allocated_dims
    |> Enum.reduce({[], []}, fn({index, num_content_cols, num_cols, num_rows, trailing_sols, trailing_blank_string, num_empty_rows}, {header_info, content_info})->
      {next_header_info, next_content_info} =
        sol_info
        |> Enum.at(index)
        |> retreive_info(lengths_tup, num_content_cols, content_col_width, num_cols, num_rows, trailing_sols, trailing_blank_string, num_empty_rows)

      {[next_header_info | header_info], [next_content_info | content_info]}
    end)
  end

  def retreive_info({letter_bank, [head_unjumbled | tail_unjumbleds], sols}, {letter_bank_length, unjumbleds_length}, num_content_cols, content_col_width, num_cols, num_rows, trailing_sols, trailing_blank_string, num_empty_rows) do
    # {
      # {
      #   letter_bank_length,
      #   unjumbleds_length
      # },
    #   num_content_cols,
    #   content_col_width,
    #   num_cols,
    #   num_rows,
    #   trailing_sols,
    #   trailing_blank_string,
    #   num_empty_rows
    # } = format_tup

    letter_bank_string =
        num_cols
        |> - letter_bank_length
        |> split_pad_rem_cap(letter_bank)
      
      num_unjumbleds =
        unjumbleds
        |> length

      header_cols = num_unjumbleds * (unjumbleds_length + 3) - 2

      total_header_pad_cols = num_cols - header_cols

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
        num_cols
        |> Helper.pad("═")

      {last_row_strings, rem_sol_strings} = 
        sols
        |> Enum.map(fn(sol_set)->
          sol_set
          |> Enum.reduce(" ", fn(sol, sol_string)->
            sol
            |> Helper.cap(sol_string, "   ")
          end)
        end)
        |> Enum.split(trailing_sols)


      last_row =
        "  "
        |> Helper.cap(last_row_strings, trailing_blank_string)
        |> IO.inspect

      # rows =
      #   rem_sol_strings
      #   |> print_rows([], num_content_cols)
        # |> Enum.map_reduce([last_row], fn(sol_strings, acc_rows)->
        #   sol
        # end)


    [bar_pad, unjumbleds_string, letter_bank_string, bar_pad]
    |> Helper.wrap_append({sol_strings, num_content_cols})
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
      [{_, _, _, max_rowspan, _, _} | _rest_allocations] =
        need_one_more
        |> Enum.map(fn({trunc, index, num_content_cols, colspan, count})->
          {trunc, index, num_content_cols + 1, colspan + col_width + 1, count}
        end)
        |> Enum.concat(finalized)
        # |> Enum.map(&Tuple.delete_at(&1, 0))
        |> Enum.map(fn({_trunc, index, num_content_cols, colspan, count})->
          {rowspan, trailing_sols, trailing_blanks} =
            num_content_cols
            |> rows_info(count)

          trailing_blank_string =
            trailing_blanks * (col_width + 1) - 1
            |> Helper.pad
            |> Helper.cap(ANSI.black_background, ANSI.white_background)

          {index, num_content_cols, colspan, rowspan, trailing_sols, trailing_blank_string}
        end)
        |> Enum.sort_by(&elem(&1, 3), &>=/2)

    allocations
    |> Enum.map(fn(dim_tup = {_, _, _, rowspan, _, _})->
      dim_tup
      |> Tuple.append(max_rowspan - rowspan)
    end)
    # |> Enum.sort_by(&elem(&1, 1), &>=/2)"                                  "
    # |> Enum.sort_by(&elem(&1, 1))
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
      {full_rows, 0, 0}
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