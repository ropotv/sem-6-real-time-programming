defmodule ClientModule do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting Client")

    children = [
      %{
        id: Connector,
        start: {Connector, :connect, ['rtp-broker', 4040]},
      },
      %{
        id: Assistant,
        start: {Assistant, :start, [["tweets"]]},
      },
      %{
        id: TwitterService,
        start: {TwitterService, :start, ["TwitterService", "RTP", "tweets", 128, 200]},
      },
      %{
        id: UsersService,
        start: {UsersService, :start, ["UsersService", "RTP", "users", 1000, 1000]},
      }
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
