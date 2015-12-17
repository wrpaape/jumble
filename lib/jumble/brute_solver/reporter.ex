defmodule Jumble.BruteSolver.Reporter do
  use GenServer

  @report_indent "\n" <> Helper.pad(4)
  @jumble_maps_key_path      ~w(jumble_info jumble_maps)a
  @letter_bank_info_key_path ~w(sol_info letter_bank_info)a
  @sols_key_path             ~w(sol_info brute sols)a
  @total_key_path            ~w(sol_info brute counts total)a
  @max_group_size_key_path   ~w(sol_info brute counts max_group_size)a
  @rem_continues_key_path    ~w(sol_info rem_continues)a

  ##################################### external API #####################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
  def start_link, do: GenServer.start_link(__MODULE__, args, name: __MODULE__)


  # ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑#
  ##################################### external API #####################################



  defp report_picks(next_total, num_uniqs, micro_sec) do
    sols_counts =
      [num_uniqs, next_total]
      |> Enum.reduce({"unique picks: ", ["/", " (solved/total)"]}, fn(int, {lcap, [rcap | rest]})->
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
      |> Helper.cap("time elapsed: ", " ms")

    [sols_counts, time_elapsed]
    |> Enum.reduce(@report_indent, fn(line, report)->
      line
      |> Helper.cap(report, @report_indent)
    end)
    |> Helper.cap(ANSI.white, "\n")
    |> IO.puts
  end
  




  ####################################### helpers ########################################
  # ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓#
end