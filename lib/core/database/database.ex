defmodule RTP.Database do
  use GenServer

  def start(bulkSize) do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27013", database: "RTP")
    IO.puts("Successfully connected to the database ")
    GenServer.start_link(
      __MODULE__,
      %{connection: conn, tweets: [], bulkSize: bulkSize},
      name: __MODULE__
    )
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def save_tweet(tweet, score) do
    GenServer.cast(__MODULE__, {:save_tweet, tweet, score})
  end

  def save_user(user) do
    GenServer.cast(__MODULE__, {:save_user, user})
  end

  @impl true
  def handle_cast({:save_tweet, tweet, score}, state) do
    result = %{id: tweet["id"], score: score, tweet: tweet}

    if length(state.tweets) == state.bulkSize do
      IO.puts("Save all #{state.bulkSize} tweets in database")

      Mongo.insert_many(state.connection, "tweets", state.tweets)

      {
        :noreply,
        %{
          connection: state.connection,
          bulkSize: state.bulkSize,
          tweets: [],
        }
      }
    else
      IO.puts("Add tweet with id #{result.id} into bulk store")

      {
        :noreply,
        %{
          connection: state.connection,
          bulkSize: state.bulkSize,
          tweets: [result | state.tweets],
        }
      }
    end
  end

  @impl true
  def handle_cast({:save_user, user}, state) do
    #  IO.puts("Save user with id" <> user["id_str"] <> " in database")
    Mongo.insert_one(state.connection, "users", user)

    {
      :noreply,
      state
    }
  end

end