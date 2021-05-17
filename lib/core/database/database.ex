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

  def save_tweet(tweet) do
    GenServer.cast(__MODULE__, {:save_tweet, tweet})
  end

  @impl true
  def handle_cast({:save_tweet, tweet}, state) do
    IO.puts("Save tweet with id" <> tweet["id_str"] <> " in database")
    Mongo.insert_one(state.connection, "tweets", tweet)

    {
      :noreply,
      state
    }
  end
end