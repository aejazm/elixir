defmodule Assessment.MixProject do
  use Mix.Project

  def project do
    [
      app: :assessment,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:geohash],
      extra_applications: [:logger, :jason, :httpoison, :memento, :geocalc],
      mod: {Assessment.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix, "~> 1.6.11"},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:jason, "~> 1.2"},
      {:memento, "~> 0.3.2"},
      {:plug_cowboy, "~> 2.5"},
      {:absinthe, "~> 1.7.0"},
      {:absinthe_plug, "~> 1.5.8"},
      {:absinthe_phoenix, "~> 2.0.2"},
      {:phoenix_pubsub, "~> 2.0"},
      {:decimal, "~> 2.0"},
      {:geohash, "~> 1.0"},
      {:httpoison, "~> 2.1.0"},
      # {:sorted_set_nif, "~> 1.2.0"},
      {:geocalc, "~> 0.8"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
