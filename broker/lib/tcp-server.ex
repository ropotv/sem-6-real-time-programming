defmodule TCPServer do
  def listen(port) do
    :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])
  end

  def accept(socket) do
    :gen_tcp.accept(socket)
  end

  def send(socket, body) do
    :gen_tcp.send(socket, body)
  end

  def read(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end
end
