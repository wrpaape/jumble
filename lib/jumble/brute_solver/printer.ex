defmodule Jumble.BruteSolver.Printer do
  alias IO.ANSI
  alias Jumble.Helper
  @sol_spacer    ANSI.white <> " or\n "

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

  defp print_solutions({rows, cols}, num_sol_groups, counts, sols) do
    counts
    |> allocate_leftover_cols(cols - num_sol_groups)
    |> IO.inspect
  end


  def init(padded_col_width) do
    [rows, cols] = get_dims

    cols
    |> num_cols(padded_col_width)
    |> Helper.wrap_prepend(rows - 2)
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  
  # fn(cols, num_sol_groups, indivs, total)->
  # f = fn(cols,  indivs)->
  #   num_sol_groups = length(indivs)
  #   total = Enum.sum(indivs)

  #   leftover_cols = cols - num_sol_groups

  #   {ordered_indivs, {_last_index, next_leftover}} =
  #     indivs
  #     |> Enum.map_reduce({1, 0}, fn(count, {index, acc_trunc})->
  #       float = count * leftover_cols / total
  #       int = trunc(float)

  #       trunc = float - int

  #       {{trunc, int + 1, index}, {index + 1, acc_trunc + trunc}}
  #     end)

  #   {need_one_more, finalized} =
  #     ordered_indivs
  #     |> Enum.sort(&>=/2)
  #     |> Enum.split(round(next_leftover))

  #   need_one_more
  #   |> Enum.map(fn({trunc, cols_allocated, index})->
  #     {trunc, cols_allocated + 1, index}
  #   end)
  #   |> Enum.concat(finalized)
  #   |> Enum.sort_by(&elem(&1, 2))
  #   |> Enum.map(&elem(&1, 1))
  # end


  def allocate_leftover_cols(%{total: total, indivs: indivs}, leftover_cols) do
    {ordered_indivs, {_last_index, next_leftover}} =
      indivs
      |> Enum.map_reduce({1, 0}, fn(count, {index, acc_trunc})->
        float = count * leftover_cols / total
        int = trunc(float)

        trunc = float - int

        {{trunc, int + 1, index}, {index + 1, acc_trunc + trunc}}
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

  defp num_cols(cols, padded_col_width) do
    cols
    |> div(padded_col_width)
    |> adjust(rem(cols, padded_col_width))
  end

  defp adjust(max_num_cols, leftover) do
    max_num_cols
    |> + if leftover > max_num_cols, do: 0, else: -1
  end 
end