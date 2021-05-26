defmodule Connector do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def connect(host, port) do
    {:ok, socket} = TCPHelper.connect(host, port)
    IO.puts("Client is connected to broker #{host}:#{port}")

    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def read() do
    GenServer.cast(__MODULE__, {:read})
  end

  def subscribe(topic) do
    GenServer.cast(__MODULE__, {:send, Poison.encode!(%{type: "subscribe", topic: topic})})
  end

  def unsubscribe(topic) do
    GenServer.cast(__MODULE__, {:send, Poison.encode!(%{type: "unsubscribe", topic: topic})})
  end

  def handle_cast({:send, data}, state) do
    TCPHelper.send(state.socket, data)

    {:noreply, state}
  end

  def handle_cast({:read}, state) do
    response = TCPHelper.read(state.socket)
    if response != :error do
      Assistant.handle_response(response)
    end
    {:noreply, state}
  end
end