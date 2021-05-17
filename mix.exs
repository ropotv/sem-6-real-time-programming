defmodule RTP.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rtp,
      version: "1.0.0",
      elixir: "~> 1.5",
      build_embedded: false,
      start_permanent: false,
      deps: [
        {:eventsource_ex, "~> 0.0.2"},
        {:poison, "~> 3.1"},
        {:mongodb, "~> 0.5.1"}
      ],
      description: "A laboratory work for University.",
      name: "RTP Lab"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {RTP.AppModule, []}
    ]
  end
end
