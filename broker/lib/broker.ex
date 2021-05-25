defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Logger.info("Broker is listening on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = TCPHelper.accept(socket)
    pid = spawn_link(__MODULE__, :read, [client])
    :gen_tcp.controlling_process(client, pid)
    loop_acceptor(socket)
  end

  def read(:error, _) do

  end

  def read(body, socket) do
    Logger.info("Got the socket body")
    Logger.info(body)

    read(socket)
  end

  def read(client) do
    response = TCPHelper.read(client)
    read(response, client)
  end
end
