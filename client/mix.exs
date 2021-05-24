defmodule ClientMixProject do
  use Mix.Project

  def project do
    [
      app: :client,
      name: "Client",
      version: "1.0.0",
      elixir: "~> 1.5",
      deps: [],
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ClientModule, []}
    ]
  end
end
