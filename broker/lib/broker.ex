defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Logger.info("Broker is listening on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TCPHelper.accept(socket)

    read_client(client)
    loop_acceptor(socket)
  end

  def read_client(:error, _) do

  end

  def read_client(body, client) do
    Logger.info("Got the client body")
    Logger.info(body)

    read_client(client)
  end

  def read_client(client) do
    response = TCPHelper.read(client)
    read_client(response, client)
  end
end
