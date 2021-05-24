defmodule TwitterService do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start(name, database, collection, bulkSize, bulkDebounce) do
    database = Database.connect(name, database, collection, bulkSize, bulkDebounce)
    Console.log("Twitter Service was Initialized")

    GenServer.start_link(__MODULE__, %{database: database}, name: __MODULE__)
  end

  def get_score(tweet) do
    wordsScoreMap = Words.getWordsScoreMap()
    words = tweet["text"]
            |> String.replace(["!", "?", ":", ",", "."], "")
            |> String.split(" ", trim: true)

    words
    |> Enum.reduce(
         0,
         fn
           word, acc -> Map.get(wordsScoreMap, String.to_atom(word), 0) + acc
         end
       )
    |> Kernel./(length(words))
  end

  @impl true
  def handle_cast({:save, tweet}, state) do
    state.database
    |> Tuple.to_list()
    |> Enum.at(1)
    |> GenServer.cast({:save, %{id: tweet["id"], score: get_score(tweet), tweet: tweet}})

    {:noreply, state}
  end
end