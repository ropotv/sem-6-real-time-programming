defmodule TwitterService do
  use GenServer

  def start() do
    database = Database.connect("TwitterDatabase", "RTP", "tweets", 128, 200)
    Console.log("Twitter Service was Initialized")

    GenServer.start_link(__MODULE__, %{database: database}, name: __MODULE__)
  end

  def init(arg) do
    {:ok, arg}
  end

  def getScore(tweet) do
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
    |> GenServer.cast({:save, %{id: tweet["id"], score: getScore(tweet), tweet: tweet}})

    {:noreply, state}
  end
end