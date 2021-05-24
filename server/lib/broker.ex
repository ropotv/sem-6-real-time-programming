defmodule Broker do
  use GenServer
  require Logger

  def init(arg) do
    {:ok, arg}
  end

  def start(host, port) do
    {:ok, socket} = TCPHelper.connect(host, port)
    Logger.info("Broker is ready to work on #{host}:#{port}")

    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def sendPacket(head, body) do
    encoded = Poison.encode!(%{head: head, body: body})
    GenServer.cast(__MODULE__, {:send_packet, encoded})
  end

  def handle_cast({:send_packet, data}, state) do
    TCPHelper.send(state.socket, data)

    {:noreply, state}
  end
end
