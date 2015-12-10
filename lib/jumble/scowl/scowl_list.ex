defmodule Jumble.Scowl.ScowlList do
  @scowl_dir Application.get_env(:jumble, :scowl_dir)
  @reg_filter  ~r/^.*[^A-Za-z\n].*\n/m
  @mk_list_opts ~w(-v3 english american british canadian 95)

  alias Jumble.LengthDict.Builder

  def build_length_dict do
    @scowl_dir
    |> Path.join("mk-list")
    |> System.cmd(@mk_list_opts, cd: @scowl_dir)
    |> elem(0)
    |> String.replace(@reg_filter, "")
    |> Builder.build
  end
end