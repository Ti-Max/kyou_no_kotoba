defmodule KyouNoKotoba.MixProject do
  use Mix.Project

  def project do
    [
      app: :kyou_no_kotoba,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {KyouNoKotoba, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nostrum, "~> 0.10"}
    ]
  end
end
