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

    try do
      TCPHelper.send(client, content)
    rescue
      _ -> IO.puts("Could not send data to the client, adding to the queue")
           Queue.add(client, content)
    end
  end

  def handle(data) do
    {:ok, decoded} = Poison.decode(data)
    topic = decoded["topic"]
    action = decoded["action"]
    clients = Registry.get(topic)

    for client <- clients  do
      handle_action(String.to_atom(action), client, decoded)
    end
  end
end
