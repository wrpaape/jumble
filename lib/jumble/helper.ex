defmodule Jumble.Helper do
  alias IO.ANSI

  @dict_sizes       Application.get_env(:jumble, :scowl_dict_sizes)
  @num_dicts        Application.get_env(:jumble, :num_scowl_dicts)
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

  def split_pad_len_rem(rem_len, parts) do
    lpad_len = div(rem_len, parts)
    rpad_len = rem(rem_len, parts) + lpad_len

    {lpad_len, rpad_len}
  end

  def split_pad_rem(rem_len) do
    {lpad_len, rpad_len} =
      rem_len
      |> split_pad_len_rem(2)

    {pad(lpad_len), pad(rpad_len)}
  end

  def split_pad_rem_cap(rem_len, string) do
    {lpad, rpad} =
      rem_len
      |> split_pad_rem

    string
    |> cap(lpad, rpad)
  end

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
      |> cap()
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







