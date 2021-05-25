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
    topic = data["topic"]
    content = data["content"]
    clients = Registry.get(topic)

    for client <- clients  do
      try do
        TCPHelper.send(client, content)
      rescue
        _ -> IO.puts("Could not send data to the client, adding to the queue")
             Queue.add(client, content)
      end
    end
  end

  def handle(client, data) do
    {:ok, decoded} = Poison.decode(data)
    handle_action(String.to_atom(decoded["action"]), client, decoded)
  end
end
