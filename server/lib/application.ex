defmodule ServerModule do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Application")

    children = [
      %{
        id: Connector,
        start: {Connector, :connect, ['rtp-broker', 4040]},
      },
      %{
        id: TwitterService,
        start: {TwitterService, :start, ["TwitterService", "RTP", "tweets", 128, 200]},
      },
      %{
        id: UsersService,
        start: {UsersService, :start, ["UsersService", "RTP", "users", 1000, 1000]},
      },
      %{
        id: FirstSource,
        start: {Fetcher, :init, ["rtp-api:4000/tweets/1"]}
      },
      %{
        id: SecondSource,
        start: {Fetcher, :init, ["rtp-api:4000/tweets/2"]}
      },
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end