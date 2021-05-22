defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Console.log("Broker is ready to work on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TCPHelper.accept(socket)
    subscribe(client)

    loop_acceptor(socket)
  end

  def subscribe(:error, _) do

  end

  def subscribe(body, socket) do
    Console.log("Got the socket body")
    IO.inspect(body)

    subscribe(socket)
  end

  def subscribe(socket) do
    body = TCPHelper.read(socket)
    subscribe(body, socket)
  end
end
