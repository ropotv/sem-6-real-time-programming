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
    GenServer.cast(__MODULE__, {:subscribe, Poison.encode!(%{type: "subscribe", topic: topic})})
  end

  def handle_cast({:subscribe, data}, state) do
    TCPHelper.send(state.socket, data)

    {:noreply, state}
  end

  def handle_cast({:read}, state) do
    encoded_data = TCPHelper.read(state.socket)
    decoded_data = Poison.decode!(encoded_data)
    IO.puts("Got the data from server")
    IO.inspect(decoded_data)

    {:noreply, state}
  end
end
