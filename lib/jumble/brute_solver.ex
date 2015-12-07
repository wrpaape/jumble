defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Helper.Stats
  alias Jumble.Helper
  alias Jumble.BruteSolver.PickTree
  alias Jumble.Countdown

  @prompt_spacer ANSI.blue  <> "solving for:\n\n "
  @sol_spacer    ANSI.white <> " or\n "
  @report_indent String.duplicate(" ", 4)
  @letter_bank_lcap     "\n  { " <> ANSI.green
  @letter_bank_rcap ANSI.magenta <> " }"
  @total_key_path ~w(sol_info brute total)a
  @sols_key_path  ~w(sol_info brute sols)a
  @show_num_results 10
  @timer_opts [
    task: {PickTree, :pick_valid_sols},
    timeout: 10,
    ticker_int: 17
  ]

##################################### external API #####################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Kernel
    |> Agent.start_link(:update_in, [args, [:jumble_info, :jumble_maps], into_map], name: __MODULE__)

    args
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    [:jumble_info, :jumble_maps, jumble, :unjumbleds]
    |> push_in_agent({unjumbled, key_letters})
  end

  def process do
    __MODULE__
    |> Agent.get(fn(%{jumble_info: %{jumble_maps: jumble_maps}})->
      jumble_maps
    end)
    |> brute_solve
  end

# ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
##################################### external API #####################################

  defp brute_solve(jumble_maps) do
    jumble_maps
    |> Enum.sort_by(&(elem(&1, 1).jumble_index), &>=/2)
    |> Enum.map(fn({_jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Stats.combinations
    |> Enum.reduce(Map.new, fn(sol_combo, sols_by_letterbank) ->
      {letter_bank, unjumbled_sols} =
        sol_combo
        |> Enum.flat_map_reduce(ANSI.magenta, fn({unjumbled, key_letters}, unjumbled_sol) ->
          {key_letters, Helper.cap(" ", unjumbled_sol, unjumbled)}
        end)

      sols_by_letterbank
      |> Map.update(Enum.sort(letter_bank, &>=/2), [unjumbled_sols], &[unjumbled_sols | &1])
      # fn(acc_sols)->
      #   @sol_spacer
      #   |> Helper.cap(acc_sols, unjumbled_sols)
      # end)
    end)
    |> Enum.each(fn({letter_bank, sols})->
      @letter_bank_lcap
      |> Helper.cap(Enum.join(sols, @sol_spacer), Enum.join(letter_bank, " "))
      |> Helper.cap(@prompt_spacer, @letter_bank_rcap)
      |> IO.puts

      letter_bank
      |> update_timer_opts
      |> Countdown.time_async
      |> report_and_record(sols, PickTree.dump_results)
    end)
  end

  defp report_and_record(time_elapsed, unjumbled_sols, results) do
    num_uniqs =
      results
      |> length

    next_total =
      @total_key_path
      |> get_in_agent
      |> + num_uniqs

    results
    |> report(num_uniqs, next_total, time_elapsed)
    
    @sols_key_path
    |> push_in_agent({unjumbled_sols, results})

    @total_key_path
    |> update_in_agent(fn _ -> next_total end)
  end

  defp report(results, num_uniqs, next_total, micro_sec) do
    samp_results =
      if num_uniqs == 0 do
        @report_indent <> "  [ none ]"
      else
        body =
          results
          |> Enum.take_random(@show_num_results)
          |> Enum.map_join("\n", fn(words)->
            words
            |> Enum.reduce(@report_indent <> "  -", fn(word, line)->
              " "
              |> Helper.cap(line, word)
            end)
          end)
        
        num_rem = num_uniqs - @show_num_results
        
        if num_rem <= 0 do
          body
        else
          rem_tail =
            num_rem
            |> Integer.to_string
            |> Helper.cap(@report_indent <> "  [ ", " more ]")

          "\n\n"
          |> Helper.cap(body, rem_tail)
        end
      end

    samp_results =
      samp_results
      |> Helper.cap("\n")

    sols_counts =
      [num_uniqs, next_total]
      |> Enum.reduce({"valid and unique: ", ["/", " (last solved/running)"]}, fn(int, {lcap, [rcap | rest]})->
        int
        |> Integer.to_string
        |> Helper.cap(lcap, rcap)
        |> Helper.wrap_append(rest)
      end)
      |> elem(0)
    
    time_elapsed =
      micro_sec
      |> div(1000)
      |> Integer.to_string
      |> Helper.cap("time elapsed:     ", " ms")

    [samp_results, sols_counts, time_elapsed]
    |> Enum.join("\n" <> @report_indent)
    |> Helper.cap(ANSI.white, "\n")
    |> IO.puts
  end

####################################### helpers ########################################
# ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#

  defp push_in_agent(key_path, el) do
    update_in_agent(key_path, &[el | &1])
  end

  defp get_in_agent(key_path) do
    __MODULE__
    |> Agent.get(Kernel, :get_in, [key_path])
  end

  defp update_in_agent(key_path, fun) do
    __MODULE__
    |> Agent.cast(Kernel, :update_in, [key_path, fun])
  end

  defp update_timer_opts(word_bank) do
    @timer_opts
    |> Keyword.update!(:task, &Tuple.append(&1, [word_bank]))
  end
end

