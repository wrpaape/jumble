defmodule Jumble.BruteSolver.PickTree do
  use GenServer

  alias Jumble.ScowlDict
  alias Jumble.BruteSolver.PickTree.Branch
  alias Jumble.BruteSolver.PickTree.Picker
  alias Jumble.Countdown
  alias Jumble.Helper
  alias Jumble.Helper.Stats

   @sol_lengths_key_path ~w(sol_info sol_lengths)a

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
  # def branch_done(branch_pid),     do: Agent.cast(:branch_stash, fn(stash)->
  #   Countdown.reset_countdown
    
  #   [branch_pid | stash]
  # end)

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  def init(args) do 
    args
    |> get_in(@sol_lengths_key_path)
    |> build_pick_orders
    |> Helper.wrap_prepend(:ok)
  end

  def handle_cast({:pick_valid_ids, letter_bank}, pick_orders) do
    pick_orders
    |> Enum.each(fn([{id_index, id_length, valid_id?} | rem_id_tups]) ->
      branch_pid =
        {letter_bank, {id_index, valid_id?}, rem_id_tups, []}
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

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp build_pick_orders(sol_lengths) do
    sol_lengths
    |> with_index_and_validator
    |> partition_dups_by_length
    |> Stats.uniq_pick_orders
  end

  defp with_index_and_validator(lengths) do
    lengths
    |> Enum.map_reduce(1, fn(length, index) ->
      valid_id? =
        length
        |> ScowlDict.safe_id_validator

      {{index, length, valid_id?}, index + 1}
    end)
    |> elem(0)
  end

  defp partition_dups_by_length(list) do
    list
    |> Enum.reduce({[], [], HashSet.new}, fn(pick = {_index, length, _valid_id?}, {uniqs, dups, uniq_vals})->
      if Set.member?(uniq_vals, length) do
        {uniqs, [pick | dups], uniq_vals}
      else
        {[pick | uniqs], dups, Set.put(uniq_vals, length)}
      end
    end)
    |> Tuple.delete_at(2)
  end
end