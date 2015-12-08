defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper

  @report_colors ANSI.white_background <> ANSI.black
  @jumble_join              ANSI.black <> " or "
  @cap_pieces [
    {"╔", "╦", "╗"},
    {"╚", "╩", "╝"}
  ]

# ┼─  ┤ ├┌┐┘├└
# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬
#wewewe
# ══════

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  def start_link(%{sol_info: %{final_length: final_length}, jumble_info: %{total_length: total_jumbles_length}}) do
    __MODULE__
    |> Agent.start_link(:init, [final_length + 2, total_jumbles_length], name: __MODULE__)
  end

  def print_solutions(num_sol_groups, counts, sols) do
     __MODULE__
     |> Agent.get(& &1)
     |> print_solutions(num_sol_groups, counts, sols)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp print_solutions({num_rows_content, total_content_cols, col_width, total_jumbles_length, pads}, num_sol_groups, counts, sol_info) do
    # IO.inspect [{num_rows_content, total_content_cols, col_width, pads}, num_sol_groups, counts, sol_info]
    allocated_cols =
      counts
      |> allocate_cols(total_content_cols - num_sol_groups, col_width)
      |> IO.inspect
    {header_info, content_info} =
     sol_info
     |> ordered_and_split_sol_info(total_jumbles_length, allocated_cols)

    header =
      header_info
      |> print_header(pads)

    content =
      content_info
      |> print_content(num_rows_content, pads)
  end

  def print_header(header_info, {lpad, rpad}) do
    # tcap =
    #   header_info
    #   |> Enum.map_join("╦", &Helper.pad(elem(&1, 1) * (col_width + 1) - 1, "═"))
    #   |> Helper.cap("╔", "╗")
    #   |> Helper.cap(@report_colors <> lpad, rpad)
  end

  def print_content(sol_info, num_rows_content, pads) do
      


  end

  def init(content_col_width, total_jumbles_length) do
    [rows, cols] = get_dims

    total_content_cols =
      cols
      |> max_num_content_cols(content_col_width)

    content_cols_with_pad_and_borders = total_content_cols * (content_col_width + 1) + 1
    
    pads =
      cols
      |> - content_cols_with_pad_and_borders
      |> split_pad_rem

    {rows - 5, total_content_cols, content_col_width, total_jumbles_length, pads}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def split_pad_rem(rem_len) do
    lpad_len = div(rem_len, 2)
    rpad_len = rem(rem_len, 2) + lpad_len

    {Helper.pad(lpad_len), Helper.pad(rpad_len)}
  end

  def ordered_and_split_sol_info(sol_info, total_jumbles_length, allocated_cols) do
    allocated_cols
    |> Enum.reduce({[], []}, fn({index, num_content_cols, num_cols}, {header_info, content_info})->
      {letter_bank, unjumbleds, sols} =
        sol_info
        |> Enum.at(index)

        rem_header_cols = 
          num_content_cols

      {[{letter_bank, unjumbleds, num_content_cols} | header_info], [{sols, num_content_cols} | content_info]}
    end)
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