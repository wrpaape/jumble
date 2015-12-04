defmodule Jumble.PickTree.Countdown do
  @timeout 3000

  alias Jumble.PickTree

  def start do
    &countdown/0
    |> spawn
    |> Process.register(__MODULE__)
  end

  def reset, do: send(__MODULE__, :reset)

  def countdown do
    receive do
      :reset ->
        countdown

      after @timeout ->
        PickTree.report_results
    end
  end
end