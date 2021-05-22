defmodule KVServer do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPServer.listen(port)
    Console.log("KVServer accepted port #{port}")

    loop_acceptor(socket)
  end

  def serve(socket) do
    body = TCPServer.read(socket)
    TCPServer.send(socket, body)

    serve(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TCPServer.accept(socket)
    serve(client)

    loop_acceptor(socket)
  end
end
