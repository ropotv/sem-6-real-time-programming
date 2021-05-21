defmodule RTP.AppModule do
  use Application

  @impl true
  def start(_type, _args) do
    Console.log("Starting Application")

    children = [
      %{
        id: Server,
        start: {RTP.Server, :start, []}
      },
      %{
        id: Database,
        start: {RTP.Database, :start, [%{bulkSize: 128, debounceTime: 200}]}
      },
      %{
        id: HTTP_1,
        start: {HttpClient, :init, ["rtp-elixir-api:4000/tweets/1"]}
      },
      %{
        id: HTTP_2,
        start: {HttpClient, :init, ["rtp-elixir-api:4000/tweets/2"]}
      },
    ]
    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end