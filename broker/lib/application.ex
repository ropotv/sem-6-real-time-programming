defmodule BrokerModule do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Broker")

    children = [
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