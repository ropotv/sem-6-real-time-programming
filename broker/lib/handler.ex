defmodule Handler do
  defp handle_action(:subscribe, client, topic) do
    Registry.add(topic, client)
  end

  defp handle_action(:unsubscribe, client, topic) do
    Registry.delete(topic, client)
  end

  defp send_content(client, content) do
    try do
      TCPHelper.send(client, content)
      IO.puts("Data was send to the client")
    rescue
      _ -> IO.puts("Could not send data to the client, adding to the queue")
           Queue.add(client, content)
    end
  end

  def handle(data, client) do
    decoded = Poison.decode!(data)
    topic = decoded["topic"]
    type = decoded["type"]

    IO.inspect("Request type is: #{type}")

    clients = Registry.get(topic)
    IO.inspect("Clients are:")
    IO.inspect(clients)

    if type == "content" do
      decoded_content = decoded["content"]
      encoded_content = Poison.encode!(decoded_content)
      for _client <- clients  do
        send_content(_client, encoded_content)
      end
    else
      handle_action(String.to_atom(type), client, topic)
    end
  end
end
