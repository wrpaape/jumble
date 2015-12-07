defmodule Jumble.BruteSolver do
  alias IO.ANSI
  alias Jumble.Stats
  alias Jumble.Helper
  alias Jumble.PickTree
  alias Jumble.Countdown

  @prompt_spacer Helper.cap("solving for:\n\n ", ANSI.blue, ANSI.magenta)
  @report_spacer ANSI.white <> "\n"
  @report_indent String.duplicate(" ", 4)
  @total_key_path ~w(sol_info brute total)a
  @sols_key_path  ~w(sol_info brute sols)a
  @show_num_results 10
  @timer_opts [
    task: {PickTree, :pick_valid_sols},
    timeout: 50,
    ticker_int: 50
  ]

  def start_link(args) do
    into_map = fn(jumble_maps) ->
      jumble_maps
      |> Enum.into(Map.new)
    end

    Kernel
    |> Agent.start_link(:update_in, [args, [:jumble_info, :jumble_maps], into_map], name: __MODULE__)

    args
  end

  def process do
    __MODULE__
    |> Agent.get(fn(%{jumble_info: %{jumble_maps: jumble_maps}})->
      jumble_maps
    end)
    |> brute_solve
  end

  def push_unjumbled(jumble, unjumbled, key_letters) do
    [:jumble_info, :jumble_maps, jumble, :unjumbleds]
    |> push_in_agent({unjumbled, key_letters})
  end

  def push_in_agent(key_path, el) do
    update_in_agent(key_path, &[el | &1])
  end

  def get_in_agent(key_path) do
    __MODULE__
    |> Agent.get(Kernel, :get_in, [key_path])
  end
  def update_in_agent(key_path, fun) do
    __MODULE__
    |> Agent.cast(Kernel, :update_in, [key_path, fun])
  end


  def update_timer_opts(word_bank) do
    @timer_opts
    |> Keyword.update!(:task, &Tuple.append(&1, [word_bank]))
  end

  def report(results, num_uniqs, next_total, micro_sec) do
    samp_results =
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

      results_tail = "\n"

      if num_rem > 0 do
        rem_tail =
          num_rem
          |> Integer.to_string
          |> Helper.cap("  - (", " more) . . .\n")

        results_tail = Helper.cap(@report_indent, results_tail, rem_tail)
      end

    sols_counts =
      [num_uniqs, next_total]
      |> Enum.reduce({"valid solutions: ", ["/", " (current/total)"]}, fn(int, {lcap, [rcap | rest]})->
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
      |> Helper.cap("time elapsed:    ", " ms")

    [samp_results <> results_tail, sols_counts, time_elapsed]
    |> Enum.join("\n" <> @report_indent)
    |> Helper.cap(@report_spacer, "\n")
    |> IO.puts
  end

  def report_and_record(time_elapsed, unjumbled_sols, results) do
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

  def brute_solve(jumble_maps) do
    jumble_maps
    |> Enum.sort_by(&(elem(&1, 1).jumble_index), &>=/2)
    |> Enum.map(fn({_jumble, %{unjumbleds: unjumbleds}}) ->
      unjumbleds
    end)
    |> Stats.combinations
    |> Enum.each(fn(sol_combo) ->
      {letter_bank, {prompt, prompt_tail}} =
        sol_combo
        |> Enum.flat_map_reduce({@prompt_spacer, "\n  ("}, fn({unjumbled, key_letters}, {unjumbled_sol, tail}) ->
          next_unjumbled_sol = Helper.cap(" ", unjumbled_sol, unjumbled)
          next_tail =          Helper.cap(" ", tail, Enum.join(key_letters, " "))

          {key_letters, {next_unjumbled_sol, next_tail}}
        end)

      prompt_tail
      |> Helper.cap(prompt, " )")
      |> IO.puts

      letter_bank
      |> Enum.sort(&>=/2)
      |> update_timer_opts
      |> Countdown.time_async
      |> report_and_record(sol_combo, PickTree.dump_results)
    end)
  end
end

