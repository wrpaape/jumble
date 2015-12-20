defmodule Jumble.Helper do
  alias IO.ANSI

  @dict_sizes       Application.get_env(:jumble, :scowl_dict_sizes)
  @num_dicts        Application.get_env(:jumble, :num_scowl_dict_sizes)
  @intensity_colors ~w(blue green yellow red magenta cyan)a
  @default_color    ANSI.white

  def string_id(string) do
    string
    |> String.codepoints
    |> Enum.sort
    |> Enum.join
  end

  def pad(pad_len, pad \\ " "), do: String.duplicate(pad, pad_len)
  
  def cap(string, lcap, rcap), do: lcap <> string <> rcap
  def cap(string, cap),        do:  cap <> string <> cap

  def wrap_prepend(second, first), do: {first, second}
  def wrap_append(first, second),  do: {first, second}

  def with_index(collection, initial) do
    collection
    |> Enum.map_reduce(initial, fn(el, acc) ->
      {{acc, el}, acc + 1}
    end)
    |> elem(0)
  end

  def div_rem(dividend, divisor), do: {div(dividend, divisor), rem(dividend, divisor)}

  def colorized_sizes do
    @intensity_colors
    |> List.foldr({[], @intensity_colors}, fn(from_rcap, {results, [from_lcap | rem_from_lcap]})->
      {[from_rcap | [from_lcap | results]], rem_from_lcap}
    end)
    |> elem(0)
    |> Stream.cycle
    |> Enum.reduce_while({Map.new, @num_dicts}, fn
      (_color, {final_color_map, 0})->
        final_color_map
        |> wrap_prepend(:halt)
      (color, {color_map, rem_counts})->
        color_map
        |> Map.update(color, 1, &(&1 + 1))
        |> wrap_append(rem_counts - 1)
        |> wrap_prepend(:cont)
    end)
    |> Enum.reduce(@dict_sizes)


    end)
      # {caps, next_rem_counts} =
      #   [1, length_colors]
      #   |> Enum.reduce_while({[], rem_counts}, fn
      #     (_cap_color, results = {_acc_cap, 0})->  
      #       {:halt, results}
      #     (cap_color, {acc_cap, next_rem_counts})->
      #       {[cap_color | acc_cap], next_rem_counts - 1}
      #       |> wrap_prepend(:cont)
      #   end)

      {caps, next_rem_counts} =
        [1, length_colors]
        |> Enum.reduce_while({[], rem_counts}, fn
          (_cap_color, results = {_acc_cap, 0})->  
            {:halt, results}
          (cap_color, {acc_cap, next_rem_counts})->
            {[cap_color | acc_cap], next_rem_counts - 1}
            |> wrap_prepend(:cont)
        end)

      caps
      |> Enum.reduce(inital_color_map, fn(cap_index, color_map)->
        color_map
        |> Map.update!(cap_index, fn({color, count})->
          {color, count + 1}
        end)
      end)


    # |> Map.update!(1, fn({color, count})-> {color, count + 1})
    # |> Map.update!(1, fn({color, count})-> {color, count + 1})
    # cond do
    #   leftover < 0 ->
    #     {left_of_mid, right_of_mid} =
    #       leftover
    #       |> split_pad_len_rem(2)

    #     index_mid =
    #       length_scale / 2
    #       |> Float.ceil
    #       |> trunc
    #       |> - 1

    #       @intensity_scale
    #       |> Enum.slice(index_mid - left_of_mid..index_mid + right_of_mid)
    #       |> List.insert_at(0, List.first(@intensity_scale))
    #       |> List.insert_at(-1, List.last(@intensity_scale))

    #   leftover > 0 ->

    #   true -> @intensity_scale
    # end
    |> Enum.map_reduce(@dict_sizes, fn(int_color, [next_size_str | rem_size_strs])->
      next_size_str
      |> Helper.cap(int_color, @default_color)
      |> Helper.wrap_append(rem_size_strs)
    end)
    |> elem(0)
  end
end







