defmodule BrokerMixProject do
  use Mix.Project

  def project do
    [
      app: :broker,
      name: "Broker",
      version: "1.0.0",
      elixir: "~> 1.5",
      deps: [],
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {BrokerModule, []}
    ]
  end
end
