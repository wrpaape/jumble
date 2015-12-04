defmodule Jumble.Stats do
  alias Jumble.Helper

  @factorial_cache 1..23
  |> Enum.scan(&(&1 * &2))
  |> Helper.with_index(1, :leading)
  |> Enum.into(Map.new)

  def combinations(list), do: combinations(list, [], [])

  def combinations([last_list], els, acc) do
    last_list
    |> Enum.reduce(acc, fn(last_el, last_acc) ->
      [[last_el | els] | last_acc]
    end)
  end

  def combinations([head_list | tail_lists], els, acc) do
    head_list
    |> Enum.reduce(acc, fn(el, next_acc) ->
      combinations(tail_lists, [el | els], next_acc)
    end)
  end

  def uniq_pick_orders(uniqs, dups) do
    uniqs
    |> permute(dups, self)

    @factorial_cache
    |> Map.get(length(uniqs))
    |> listen([])
  end

  def listen(0, final_perms), do: final_perms

  def listen(num_rem_perms, acc_perms) do
    receive do
      {:branch_finished, perms} ->
        num_rem_perms
        |> - 1
        |> listen([perms | acc_perms])
    end
  end

  def permute([last_el], last_acc, root_pid) do
    root_pid
    |> send({:branch_finished, [last_el | last_acc]})
  end

  def permute(rem, acc, root_pid) do
    rem
    |> Enum.scan({[], rem}, fn(_el, {ahead, [el | behind]})->
      __MODULE__
      |> spawn(:permute, [ahead ++ behind, [el | acc], root_pid])

      {[el | ahead], behind}
    end)
  end
end