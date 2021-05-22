defmodule Broker do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link(host, port) do
    {:ok, socket} = TCPServer.connect(host, port)
    Console.log("Broker is ready to work")

    GenServer.start_link(__MODULE__, %{socket: socket}, name: __MODULE__)
  end

  def send(head, body) do
    GenServer.cast(__MODULE__, {:send, {head, body}})
  end

  def handle_cast({:send, {head, body}}, state) do
    TCPServer.send(state.socket, %{head: head, body: body})

    {:noreply, state}
  end
end
