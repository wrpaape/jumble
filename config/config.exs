defmodule PathHelper do
  def rel_lib_path(path_list) do
    ~w(.. .. lib)
    |> Enum.concat(path_list)
    |> Path.join
    |> Path.expand(Mix.Project.build_path)
  end
end

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

use Mix.Config

length_dict_dir =
  ~w(jumble length_dict)
  |> PathHelper.rel_lib_path

scowl_dict_dir =
  ~w(jumble scowl_dict)
  |> PathHelper.rel_lib_path

scowl_dir =
  ~w(jumble scowl)
  |> PathHelper.rel_lib_path

scowl_dict_sizes = ~w(10 20 35 40 50 55 60 70 80 95)

config :jumble,
  [
    dict_path:        Path.join(~w(/ usr share dict words)),
    length_dict_dir:  length_dict_dir,
    scowl_dir:        scowl_dir,
    scowl_dict_dir:   scowl_dict_dir,
    scowl_dict_sizes: scowl_dict_sizes,
    num_scowl_dicts:  length(scowl_dict_sizes)
  ]

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :jumble, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:jumble, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
