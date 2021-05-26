defmodule Assistant do

  def init(arg) do
    {:ok, arg}
  end

  def start(topics) do
    for topic <- topics do
      Connector.subscribe(topic)
      IO.puts("Client was subscribed to topic: #{topic}")
    end

    loop_acceptor()
  end


  defp loop_acceptor() do
    Connector.read()
    loop_acceptor()
  end

  def handle_response(response) do
    decoded = Poison.decode!(response)
    IO.puts("Got the data from server")
    IO.inspect(decoded)
  end
end
