defmodule RealTimeLinearRegression.MixProject do
  use Mix.Project

  def project do
    [
      app: :linear_r,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nx, "~> 0.5"},
      {:explorer, "~> 0.5.0"},
      {:exla, "~> 0.5"},
      {:axon, "~> 0.5"},
      {:vega_lite, "~> 0.1.6"},
      {:kino_vega_lite, "~> 0.1.6"},
      {:scidata, "~> 0.1"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:tzdata, "~> 1.0"},
      {:scholar, "~> 0.1"},
      {:binance, "~> 2.0.1"}
    ]
  end
end
