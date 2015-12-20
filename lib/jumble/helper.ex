defmodule Jumble.Helper do
  alias IO.ANSI

  @dict_sizes       Application.get_env(:jumble, :scowl_dict_sizes)
  @num_dicts        Application.get_env(:jumble, :num_scowl_dicts)
  # @intensity_colors ~w(blue green yellow red magenta cyan)a
  @intensity_colors ~w(cyan magenta red yellow green blue)a
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
    |> Enum.reduce_while({Keyword.new(@intensity_colors, &{&1, 0}), @num_dicts}, fn
      (_color, {final_counts, 0})->
        final_counts
        |> wrap_prepend(:halt)
      (color, {counts, rem_counts})->
        counts
        |> Keyword.update!(color, &(&1 + 1))
        |> wrap_append(rem_counts - 1)
        |> wrap_prepend(:cont)
    end)
    |> Enum.flat_map(fn({color, count})->
      ANSI
      |> apply(color, [])
      |> List.duplicate(count)
    end)
    |> Enum.map_reduce(@dict_sizes, fn(color, [next_dict_size | rem_dict_sizes])->
      next_dict_size
      |> cap(color, @default_color)
      |> wrap_append(rem_dict_sizes)
    end)
    |> elem(0)
  end
end







