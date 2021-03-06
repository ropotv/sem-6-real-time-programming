defmodule EventsourceEx.Mixfile do
  use Mix.Project

  def project do
    [
      app: :rtp_lab,
      version: "1.0.0",
      elixir: "~> 1.5",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      description: "A laboratory work for University.",
      name: "RTP Lab"
    ]
  end

  def application do
    [applications: [:logger]]
  end


  defp deps do
    [
      {:eventsource_ex, "~> 0.0.2"}
    ]
  end
end
