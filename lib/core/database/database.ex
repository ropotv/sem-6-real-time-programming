defmodule RTP.Database do
  use GenServer

  def start() do
    {:ok, conn} = Mongo.start_link(url: "mongodb://localhost:27013", database: "RTP")
    IO.puts("Successfully connected to the database ")
    GenServer.start_link(
      __MODULE__,
      %{connection: conn},
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
    IO.puts("Save tweet with id" <> tweet["id_str"] <> " and score " <> Float.to_string(score) <> " in database")

    result = %{id: tweet["id"], score: score, tweet: tweet}
    Mongo.insert_one(state.connection, "tweets", result)

    {
      :noreply,
      state
    }
  end

  @impl true
  def handle_cast({:save_user, user}, state) do
    IO.puts("Save user with id" <> user["id_str"] <> " in database")
    Mongo.insert_one(state.connection, "users", user)

    {
      :noreply,
      state
    }
  end

end