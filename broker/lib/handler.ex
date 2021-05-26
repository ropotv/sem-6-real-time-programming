defmodule Handler do
  defp handle_action(:subscribe, client, data) do
    topic = data["topic"]
    Registry.add(topic, client)
  end

  defp handle_action(:unsubscribe, client, data) do
    topic = data["topic"]
    Registry.delete(topic, client)
  end

  defp handle_action(:content, client, data) do
    content = data["content"]
    {:ok, encoded} = Poison.encode!(content)

    send_content(client, encoded)
  end

  def send_content(client, content) do
    try do
      TCPHelper.send(client, content)
      IO.puts("Data was send to the client")
    rescue
      _ -> IO.puts("Could not send data to the client, adding to the queue")
           Queue.add(client, content)
    end
  end

  def handle(data) do
    decoded = Poison.decode!(data)
    topic = decoded["topic"]
    type = decoded["type"]

    IO.inspect("Request type is: #{type}")

    clients = Registry.get(topic)
    IO.inspect("Clients are:")
    IO.inspect(clients)

    for client <- clients  do
      handle_action(String.to_atom(type), client, decoded)
    end
  end
end
