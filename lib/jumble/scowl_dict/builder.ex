defmodule Jumble.ScowlDict.Builder do
  @scowl_dir    Application.get_env(:jumble, :scowl_dir)
  @mk_list_opts ~w(-v3 english american british canadian 50)
  @reg_filter   ~r/^.*[^A-Za-z\n].*\n/m

  alias Jumble.LengthDict.Builder

  def build_length_dict do
    @scowl_dir
    |> Path.join("mk-list")
    |> System.cmd(@mk_list_opts, cd: @scowl_dir)
    |> elem(0)
    |> String.replace(@reg_filter, "")
    |> String.downcase
    |> String.split
    |> Enum.uniq
    |> Builder.build
  end


  def build do
    @scowl_dir
    |> Path.join()

  end

  def clean do
    Path.join(@dir, "length_*.ex")
    |> Path.wildcard
    |> Enum.each(&File.rm/1)
  end
end