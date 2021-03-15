defmodule RTP.AppModule do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts "starting"

    children = [
      %{
        id: Navigator,
        start: {Navigator, :start, []}
      },
      %{
        id: Tweets1,
        start: {Fetcher, :init, ["localhost:4000/tweets/1"]}
      },
      %{
        id: Tweets2,
        start: {Fetcher, :init, ["localhost:4000/tweets/2"]}
      }
    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end