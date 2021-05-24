defmodule ClientModule do
  use Application
  require Logger

  @impl true
  def start(_type, _args) do
    Logger.info("Starting Client")

    children = []
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
