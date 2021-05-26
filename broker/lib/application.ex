defmodule BrokerModule do
  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting Broker")

    children = [
      %{
        id: Queue,
        start: {Queue, :start_link, []}
      },
      %{
        id: Queue.Manager,
        start: {Queue.Manager, :start_link, []}
      },
      %{
        id: Registry,
        start: {Registry, :init, []}
      },
      %{
        id: Broker,
        start: {Broker, :accept, [4040]}
      }
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end