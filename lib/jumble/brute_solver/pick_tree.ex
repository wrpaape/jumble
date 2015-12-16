defmodule Jumble.BruteSolver.PickTree do
  use GenServer

  alias Jumble.ScowlDict
  alias Jumble.BruteSolver.PickTree.Branch
  alias Jumble.BruteSolver.PickTree.Picker
  alias Jumble.Countdown
  alias Jumble.Helper
  alias Jumble.Helper.Stats

  @pick_orders_key_path ~w(sol_info pick_orders)a

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args) do
    __MODULE__
    |> GenServer.start_link(args, name: __MODULE__)

    Agent.start_link(fn -> [] end, name: :branch_stash)

    args
  end

  def pick_valid_ids(letter_bank), do: GenServer.cast(__MODULE__, {:pick_valid_ids, letter_bank})

  def put_ids(string_ids),         do: GenServer.cast(__MODULE__, {:put_ids, string_ids})

  def dump_ids,                    do: GenServer.call(__MODULE__, :dump_ids)

  def state,                       do: GenServer.call(__MODULE__, :state)

  def branch_done(branch_pid),     do: Agent.cast(:branch_stash, &[branch_pid | &1])

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(args) do 
    args
    |> get_in(@pick_orders_key_path)
    |> Helper.wrap_prepend(:ok)
  end

  def handle_cast({:pick_valid_ids, letter_bank}, pick_orders) do
    pick_orders
    |> Enum.each(fn([id_tup = {_id_index, id_length} | rem_id_tups]) ->
      branch_pid =
        {letter_bank, id_tup, rem_id_tups, []}
        |> Branch.new_branch

      Picker
      |> spawn(:start_next_id, [{letter_bank, id_length, branch_pid}])
    end)

    {:noreply, HashSet.new}
  end

  def handle_cast({:put_ids, string_ids}, valid_ids) do
    Countdown.reset_countdown

    valid_ids
    |> Set.put(string_ids)
    |> Helper.wrap_prepend(:noreply)
  end

  def handle_call(:dump_ids, _from, final_ids) do
    {:stop, :normal, final_ids, Agent.get(:branch_stash, & &1)}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def terminate(:normal, branch_pids) do
    :branch_stash
    |> Agent.stop

    branch_pids
    |> Enum.each(fn(branch_pid)->
      branch_pid
      |> Process.exit(:normal)
    end)
  end
end