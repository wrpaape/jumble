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
    # intensity_colors = 
    #   @intensity_colors
    #   |> Enum.map(&apply(ANSI, &1, [])))
    
    length_colors =
      intensity_colors
      |> length

    {inital_count, rem_counts} =
      @num_dicts
      |> div_rem(length_colors)


    # leftover = @num_dicts - length_scale

    intensity_colors
    |> Enum.reduce({Map.new, 1}, fn(color, {color_map, index})->
      color_map
      |> Map.put(index, {color, inital_count})
    end)
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







