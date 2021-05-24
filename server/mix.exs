defmodule ServerMixProject do
  use Mix.Project

  def project do
    [
      app: :app,
      name: "Server",
      version: "1.0.0",
      elixir: "~> 1.5",
      deps: [
        {:eventsource_ex, "~> 0.0.2"},
        {:poison, "~> 3.1"},
      ],
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ServerModule, []}
    ]
  end
end
