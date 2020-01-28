defmodule BoatServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :boat_server,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets, :prometheus_ex],
      mod: {BoatServer.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, ">= 1.1.1"},
      {:prometheus_ex, ">= 3.0.0"},
      {:plug_cowboy, "~> 2.1"},
      {:prometheus_plugs, "~> 1.1"}
    ]
  end
end
