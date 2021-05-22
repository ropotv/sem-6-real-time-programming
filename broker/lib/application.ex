defmodule ApplicationModule do
  use Application

  @impl true
  def start(_type, _args) do
    Console.log("Starting Broker")

    children = [
      %{
        id: Broker,
        start: {Broker, :accept, [4040]}
      }
    ]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end