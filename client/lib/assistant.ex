defmodule Assistant do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start(topics) do
    for topic <- topics do
      Connector.subscribe(topic)
      IO.puts("Client was subscribed to topic: #{topic}")
    end

    twitterService = TwitterService.start("TwitterService", "RTP", "tweets", 128, 200)
    usersService = UsersService.start("UsersService", "RTP", "users", 1000, 1000)

    GenServer.start_link(__MODULE__, %{twitterService: twitterService, usersService: usersService}, name: __MODULE__)

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
    GenServer.cast(__MODULE__, {:save, decoded})
  end


  def handle_cast({:save, data}, state) do
    topic = data["topic"]
    content = data["content"]

    case topic do
      "tweets" -> state.twitterService
                  |> Tuple.to_list()
                  |> Enum.at(1)
                  |> GenServer.cast({:save, content})

      "users" -> state.usersService
                 |> Tuple.to_list()
                 |> Enum.at(1)
                 |> GenServer.cast({:save, content})
    end



    {:noreply, state}
  end
end
