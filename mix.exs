defmodule Jumble.Mixfile do
  use Mix.Project

  def project do
    [
      app: :jumble,
      version: "0.0.1",
      elixir: "~> 1.1",
      name: "Jumble",
      source_url: "https://github.com/wrpaape/jumble",
      escript: escript_config,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      erl: "+P 1_000_000"
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # {:gibran, ">= 0.0.0"}
    ]
  end

  defp escript_config do
    [
      main_module: Jumble.CLI
    ]
  end
end
