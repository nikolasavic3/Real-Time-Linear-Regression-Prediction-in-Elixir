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
      {:scholar, "~> 0.1"},
      {:nx, "~> 0.6.0"},
      {:vega_lite, "~> 0.1.6"},
      {:kino_vega_lite, "~> 0.1.6"},
      {:scidata, "~> 0.1"},
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.0"},
      {:tzdata, "~> 1.0"},
      {:explorer, "~> 0.2.0"}
    ]
  end
end
