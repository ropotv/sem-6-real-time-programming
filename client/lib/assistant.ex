defmodule Assistant do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start(tweetsLimit, usersLimit) do
    twitterService = TwitterService.start("TwitterService", "RTP", "tweets", 20, 200)
    usersService = UsersService.start("UsersService", "RTP", "users", 20, 1000)

    if tweetsLimit > 0 do
      Connector.subscribe("tweets")
      IO.puts("Client was subscribed to topic: tweets")
    end

    if usersLimit > 0 do
      Connector.subscribe("users")
      IO.puts("Client was subscribed to topic: users")
    end

    GenServer.start_link(
      __MODULE__,
      %{
        twitterService: twitterService,
        tweetsSaved: 0,
        tweetsLimit: 10,
        usersService: usersService,
        usersSaved: 0,
        usersLimit: 5
      },
      name: __MODULE__
    )

    loop_acceptor()
  end


  defp loop_acceptor() do
    Connector.read()
    loop_acceptor()
  end

  def handle_response(response) do
    decoded = Poison.decode!(response)
    GenServer.cast(__MODULE__, {:save, decoded})
  end


  def handle_cast({:save, data}, state) do
    topic = data["topic"]
    content = data["content"]
    IO.inspect(state)

    IO.puts("Tweets Saved: #{state.tweetsSaved}")
    IO.puts("Users Saved: #{state.usersSaved}")

    if content do
      case topic do
        "tweets" -> if state.tweetsLimit > 0 do
                      if state.tweetsSaved < state.tweetsLimit do
                        IO.puts("Got the tweet from server")
                        IO.inspect(content)
                        state.twitterService
                        |> Tuple.to_list()
                        |> Enum.at(1)
                        |> GenServer.cast({:save, content})
                        {
                          :noreply,
                          %{
                            twitterService: state.twitterService,
                            tweetsSaved: state.tweetsSaved + 1,
                            tweetsLimit: state.tweetsLimit,
                            usersService: state.usersService,
                            usersSaved: state.usersSaved,
                            usersLimit: state.usersLimit
                          }
                        }
                      else
                        Connector.unsubscribe("tweets")
                        IO.puts("Client was unsubscribed from topic: tweets")
                        {:noreply, state}
                      end
                    else
                      {:noreply, state}
                    end


        "users" -> if state.usersLimit > 0 do
                     if state.usersSaved < state.usersLimit do
                       IO.puts("Got the user from server")
                       IO.inspect(content)
                       state.usersService
                       |> Tuple.to_list()
                       |> Enum.at(1)
                       |> GenServer.cast({:save, content})
                       IO.puts("Add to user")
                       {
                         :noreply,
                         %{
                           twitterService: state.twitterService,
                           tweetsSaved: state.tweetsSaved,
                           tweetsLimit: state.tweetsLimit,
                           usersService: state.usersService,
                           usersSaved: state.usersSaved + 1,
                           usersLimit: state.usersLimit
                         }
                       }
                     else
                       Connector.unsubscribe("users")
                       IO.puts("Client was unsubscribed from topic: users")
                       {:noreply, state}
                     end
                   else
                     {:noreply, state}
                   end
        true -> {:noreply, state}
      end
    else
      {:noreply, state}
    end
  end
end
