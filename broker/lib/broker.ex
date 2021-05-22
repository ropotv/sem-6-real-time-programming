defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Console.log("Broker is ready to work on port #{port}")

    loop_acceptor(socket)
  end

  def serve(socket) do
    body = TCPHelper.read(socket)
    TCPHelper.send(socket, body)

    serve(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TCPHelper.accept(socket)
    serve(client)

    loop_acceptor(socket)
  end
end
