defmodule Jumble.BruteSolver.Recorder do
  use GenServer
  alias Jumble.Helper
  alias Jumble.BruteSolver.Reporter

  @report_indent "\n" <> Helper.pad(4)
  @jumble_maps_key_path      ~w(jumble_info jumble_maps)a
  @letter_bank_info_key_path ~w(sol_info letter_bank_info)a
  @sols_key_path             ~w(sol_info brute sols)a
  @total_key_path            ~w(sol_info brute counts total)a
  @max_group_size_key_path   ~w(sol_info brute counts max_group_size)a
  @rem_continues_key_path    ~w(sol_info rem_continues)a





  def handle_pick_info(time_elapsed, letter_bank_string, rem_inc_timer_opts, unjumbleds, picks) do
    num_uniqs =
      picks
      |> Set.size

    @total_key_path
    |> get_and_inc_in_agent(num_uniqs)
    |> Reporter.report_picks(num_uniqs, time_elapsed)

    if num_uniqs > 0 do
      letter_bank =
        ANSI.magenta
        <> letter_bank_string

      group_size =
        unjumbleds
        |> length

      unjumbleds_tup =
        unjumbleds
        |> Helper.wrap_append(group_size)

      pick_info = {letter_bank, rem_inc_timer_opts, unjumbleds_tup, num_uniqs, picks}
      
      @sols_key_path
      |> push_in_agent(pick_info)

      @max_group_size_key_path
      |> update_in_agent(&max(&1, group_size))
    end
  end

end