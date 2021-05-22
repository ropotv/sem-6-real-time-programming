defmodule Mixfile do
  use Mix.Project

  def project do
    [
      app: :app,
      name: "Application",
      version: "1.0.0",
      elixir: "~> 1.5",
      deps: [
        {:eventsource_ex, "~> 0.0.2"},
        {:poison, "~> 3.1"},
        {:mongodb, "~> 0.5.1"}
      ],
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ApplicationModule, []}
    ]
  end
end
