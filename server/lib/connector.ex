defmodule Connector do
  use GenServer
  require Logger

  def init(arg) do
    {:ok, arg}
  end

  def connect(host, port) do
    {:ok, socket} = TCPHelper.connect(host, port)
    Logger.info("Server is connected to broker #{host}:#{port}")

    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def send_packet(topic, content) do
    GenServer.cast(__MODULE__, {:send_packet, %{topic: topic, content: content}})
  end

  def handle_cast({:send_packet, data}, state) do
    TCPHelper.send(state.socket, Poison.encode!(data))

    {:noreply, state}
  end
end
