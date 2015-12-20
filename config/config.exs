# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.

use Mix.Config

rel_lib_path = fn(path_list)->
  ~w(.. .. lib)
  |> Enum.concat(path_list)
  |> Path.join
  |> Path.expand(Mix.Project.build_path)
end

config :jumble,
  [
    # dict_path:        Path.join(~w(/ usr share dict words)),
    scowl_dir:        rel_lib_path.(~w(jumble scowl)),
    scowl_dict_dir:   rel_lib_path.(~w(jumble scowl_dict)),
    scowl_categories: ~w(english-words variant_1-words),
    scowl_dict_sizes: ~w(10 20 35 40 50 55 60 70 80 95)
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
