defmodule ApplicationModule do
  use Application

  @impl true
  def start(_type, _args) do
    Console.log("Starting Application")

    children = [
      %{
        id: Server,
        start: {Server, :start, []}
      },
      %{
        id: FirstTweets,
        start: {Fetcher, :init, ["rtp-elixir-api:4000/tweets/1"]}
      },
      %{
        id: SecondTweets,
        start: {Fetcher, :init, ["rtp-elixir-api:4000/tweets/2"]}
      },
    ]
    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end
end