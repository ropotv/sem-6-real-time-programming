defmodule Assistant do

  def init(arg) do
    {:ok, arg}
  end

  def start(topics) do
    for topic <- topics do
      Connector.subscribe(topic)
      IO.inspect("Client was subscribed to topic: #{topic}")
    end

    loop_acceptor()
  end


  def loop_acceptor do
    loop_acceptor()
  end
end
