defmodule RTP.AppModule do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts "Starting Application"

    children = [
      %{
        id: Server,
        start: {RTP.Server, :start, []}
      },
      %{
        id: HTTP_1,
        start: {HttpClient, :init, ["localhost:3000/tweets/1"]}
      },
      %{
        id: HTTP_2,
        start: {HttpClient, :init, ["localhost:3000/tweets/2"]}
      }
    ]

    opts = [strategy: :one_for_one, name: RTP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end