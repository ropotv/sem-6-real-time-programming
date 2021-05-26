defmodule Broker do
  require Logger

  def accept(port) do
    {:ok, socket} = TCPHelper.listen(port)
    Logger.info("Broker is listening on port #{port}")

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, server} = TCPHelper.accept(socket)
    pid = spawn_link(__MODULE__, :read, [server])
    :gen_tcp.controlling_process(server, pid)
    loop_acceptor(socket)
  end

  def read(:error, server) do
    read(server)
  end

  def read(body, server) do
    Logger.info("Got the client body")
    Handler.handle(server)
    read(server)
  end

  def read(server) do
    response = TCPHelper.read(server)
    read(response, server)
  end
end
