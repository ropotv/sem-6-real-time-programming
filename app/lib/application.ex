defmodule ApplicationModule do
  use Application

  @impl true
  def start(_type, _args) do
    Console.log("Starting Application")

    children = [
      %{
        id: Dispatcher,
        start: {Dispatcher, :start, []}
      },
      %{
        id: Broker,
        start: {Broker, :start_link, ['rtp-elixir-broker', 4040]},
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
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end