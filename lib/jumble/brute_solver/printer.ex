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
# ║ foo bar foo ║ foo bax doo ║ fee doo daa ║
# cols =         43
# final_length = 11

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

  defp print_solutions({rows, cols, col_width, lpad, rpad}, num_sol_groups, counts, sols) do
    allocated_cols =
      counts
      |> allocate_cols(cols - num_sol_groups)

    tcap =
      allocated_cols
      |> IO.inspect
      |> Enum.map_join("╦", &String.duplicate("═", &1 * (col_width + 1) - 1))
      |> Helper.cap("╔", "╗")
      |> Helper.cap(@report_colors <> lpad, rpad <> "x")
      |> IO.puts
  end

  def print_rows(allocated_cols, sols) do

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
    {ordered_indivs, {_last_index, next_leftover}} =
      indivs
      |> Enum.map_reduce({1, 0}, fn(count, {index, acc_trunc})->
        float = count * leftover_cols / total
        leftover_cols_allocated = trunc(float)

        trunc = float - leftover_cols_allocated

        {{trunc, leftover_cols_allocated + 1, index}, {index + 1, acc_trunc + trunc}}
      end)

    {need_one_more, finalized} =
      ordered_indivs
      |> Enum.sort(&>=/2)
      |> Enum.split(round(next_leftover))

    need_one_more
    |> Enum.map(fn({trunc, cols_allocated, index})->
      {trunc, cols_allocated + 1, index}
    end)
    |> Enum.concat(finalized)
    |> Enum.sort_by(&elem(&1, 2))
    |> Enum.map(&elem(&1, 1))
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