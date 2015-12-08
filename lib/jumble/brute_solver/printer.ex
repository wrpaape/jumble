defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper
  @sol_spacer               ANSI.white <> " or\n "
  @report_colors ANSI.white_background <> ANSI.black
  @cap_pieces [
    {"╔", "╦", "╗"},
    {"╚", "╩", "╝"}
  ]

# ┼─  ┤ ├┌┐┘├└
# ═ ║ ╒ ╓ ╔ ╕ ╖ ╗ ╘ ╙ ╚ ╛ ╜ ╝ ╞ ╟ ╠ ╡ ╢ ╣ ╤ ╥ ╦ ╧ ╨ ╩ ╪ ╫ ╬
#

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  def start_link(%{sol_info: %{final_length: final_length}}) do
    __MODULE__
    |> Agent.start_link(:init, [final_length + 2], name: __MODULE__)
  end

  def print_solutions(num_sol_groups, counts, sols) do
     __MODULE__
     |> Agent.get(& &1)
     |> print_solutions(num_sol_groups, counts, sols)
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp print_solutions({num_rows_content, num_cols_content, col_width, lpad, rpad}, num_sol_groups, counts, sols) do
    IO.inspect [{num_rows_content, num_cols_content, col_width, lpad, rpad}, num_sol_groups, counts, sols]
    # allocated_cols =
    #   counts
    #   |> allocate_cols(num_cols_content - num_sol_groups)

    # tcap =
    #   allocated_cols
    #   |> Enum.map_join("╦", &String.duplicate("═", elem(&1, 1) * (col_width + 1) - 1))
    #   |> Helper.cap("╔", "╗")
    #   |> Helper.cap(@report_colors <> lpad, rpad)

    # content =
    #   allocated_cols
    #   |> print_content(sols, num_rows_content)
  end

  def print_content(allocated_cols, sols) do
    allocated_cols
    |> Enum.map_reduce([], fn({index, content_cols})->
      sols
      |> Enum.at(index)
      |> Tuple.append(content_cols)
    end)

  end

  def init(content_col_width) do
    [rows, cols] = get_dims

    num_cols_content =
      cols
      |> max_num_cols_content(content_col_width)

    cols_content = num_cols_content * (content_col_width + 1) + 1
    
    leftover = cols - cols_content

    lpad_len = div(leftover, 2)
    rpad_len = rem(leftover, 2) + lpad_len

    [lpad, rpad] = 
      [lpad_len, rpad_len]
      |> Enum.map(&String.duplicate(" ", &1))

    {rows - 2, num_cols_content, content_col_width, lpad, rpad}
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  def allocate_cols(_counts, leftover_cols) when leftover_cols < 0, do: "not enough room!"

  def allocate_cols(%{total: total, indivs: indivs}, leftover_cols) do
    {indexed_indivs, {_last_index, next_leftover}} =
      indivs
      |> Enum.map_reduce({0, 0}, fn(count, {index, acc_trunc})->
        float = count * leftover_cols / total
        leftover_cols_allocated = trunc(float)

        trunc = float - leftover_cols_allocated

        {{trunc, index, leftover_cols_allocated + 1}, {index + 1, acc_trunc + trunc}}
      end)

    {need_one_more, finalized} =
      indexed_indivs
      |> Enum.sort(&>=/2)
      |> Enum.split(round(next_leftover))

    need_one_more
    |> Enum.map(fn({trunc, index, cols_allocated})->
      {trunc, index, cols_allocated + 1}
    end)
    |> Enum.concat(finalized)
    |> Enum.map(&Tuple.delete_at(&1, 0))
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
  end

  defp get_dims do
    [:rows, :columns]
    |> Enum.map(fn(dim_fun)->
      :io
      |> apply(dim_fun, [])
      |> elem(1)
    end)
  end

  defp max_num_cols_content(all_cols, col_width) do
    max_cols_content = all_cols - 2

    max_cols_content
    |> div(col_width)
    |> adjust(rem(max_cols_content, col_width))
  end

  defp adjust(max_num_cols_content, leftover_content) do
    max_num_cols_content
    |> + if leftover_content > max_num_cols_content, do: 0, else: -1
  end 
end