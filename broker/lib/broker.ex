defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Logger.info("Broker is listening on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, sock} = TCPHelper.accept(socket)

    read(sock)
    loop_acceptor(socket)
  end

  def read(:error, _) do

  end

  def read(body, socket) do
    Logger.info("Got the socket body")
    Logger.info(body)

    read(socket)
  end

  def read(socket) do
    response = TCPHelper.read(socket)
    read(response, socket)
  end
end
