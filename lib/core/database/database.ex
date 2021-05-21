defmodule RTP.Database do
  use GenServer

  def start(initialState) do
    {:ok, conn} = Mongo.start_link(url: "mongodb://rtp-elixir-database:27017", database: "RTP")
    Console.log("Successfully connected to the database")
    GenServer.start_link(
      __MODULE__,
      %{
        connection: conn,
        bulkSize: initialState.bulkSize,
        debounceTime: initialState.debounceTime,
        previousTime: :os.system_time(:millisecond),
        tweets: [],
        users: [],
      },
      name: __MODULE__
    )
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  def save_tweet_and_user(tweet, user) do
    GenServer.cast(__MODULE__, {:save_tweet_and_user, tweet, user})
  end

  @impl true
  def handle_cast({:save_tweet_and_user, tweet, user}, state) do
    currentTime = :os.system_time(:millisecond)

    if length(state.tweets) == state.bulkSize or currentTime - state.previousTime > state.debounceTime do
      Console.log(
        "Save all #{length(state.tweets)} tweets and users in database with the time #{
          currentTime - state.previousTime
        }"
      )

      Mongo.insert_many(state.connection, "tweets", state.tweets)
      Mongo.insert_many(state.connection, "users", state.users)

      {
        :noreply,
        %{
          connection: state.connection,
          bulkSize: state.bulkSize,
          debounceTime: state.debounceTime,
          previousTime: :os.system_time(:millisecond),
          users: [],
          tweets: [],
        }
      }
    else
      Console.log("Add tweet with id #{tweet.id} and user with id #{user["id"]} into bulk store")

      {
        :noreply,
        %{
          connection: state.connection,
          bulkSize: state.bulkSize,
          debounceTime: state.debounceTime,
          previousTime: state.previousTime,
          users: [user | state.users],
          tweets: [tweet | state.tweets],
        }
      }
    end
  end

end