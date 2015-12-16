defmodule Jumble.BruteSolver.PickTree do
  use GenServer

  alias Jumble.BruteSolver.PickTree.Branch
  alias Jumble.BruteSolver.PickTree.Picker
  alias Jumble.Countdown
  alias Jumble.Helper

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args = %{sol_info: sol_info}) do
    __MODULE__
    |> GenServer.start_link(sol_info, name: __MODULE__)

    args
  end

  def pick_valid_ids(letter_bank), do: GenServer.cast(__MODULE__, {:pick_valid_ids, letter_bank})

  def put_ids(string_ids),         do: GenServer.cast(__MODULE__, {:put_ids, string_ids})

  def branch_done,                 do: GenServer.call(__MODULE__, :branch_done)

  def dump_ids,                    do: GenServer.call(__MODULE__, :dump_ids)

  # def shutdown,                    do: GenServer.cast(__MODULE__, :shutdown)

  def state,                       do: GenServer.call(__MODULE__, :state)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(sol_info), do: {:ok, {{HashSet.new, []}, sol_info}}

  def handle_cast({:pick_valid_ids, letter_bank}, initial_state = {_acc_tup, %{pick_orders: pick_orders}}) do
    pick_orders
    |> Enum.each(fn([first_id_tup = {_first_id_index, first_id_length} | rem_id_tups]) ->
      branch_pid =
        {letter_bank, first_id_tup, rem_id_tups, []}
        |> Branch.new_branch

      Picker
      |> spawn(:start_next_id, [{letter_bank, first_id_length, branch_pid}])
    end)

    {:noreply, initial_state}
  end

  def handle_cast({:put_ids, string_ids}, {{valid_ids, branch_pids}, sol_info}) do
    Countdown.reset_countdown

    {:noreply, {{Set.put(valid_ids, string_ids), branch_pids}, sol_info}}
  end

  def handle_call(:branch_done, {branch_pid, _ref}, {{valid_ids, branch_pids}, sol_info}) do

    {:reply, :done, {{valid_ids, [branch_pid | branch_pids]}, sol_info}}
  end

  def handle_call(:dump_ids, _from, {{final_ids, branch_pids}, _sol_info}) do
    {:stop, :shutdown, final_ids, branch_pids}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:shutdown, _branch_pids), do: {:stop, :shutdown}

  def terminate(:shutdown, branch_pids) do
    IO.puts "killing self"
    branch_pids
    |> Enum.shuffle
    |> Enum.each(&Agent.stop(&1, :infinity))
  end
end