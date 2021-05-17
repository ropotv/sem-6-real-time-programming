defmodule Emotions.Service do
  use GenServer

  def start() do
    GenServer.start_link(__MODULE__, :ok, name: {:global, 0})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  def getScore(tweet) do
    emotions = tweet["text"]
               |> String.replace(["!", "?", ":", ",", "."], "")
               |> String.split(" ", trim: true)

    emotions
    |> Enum.reduce(
         0,
         fn
           emotion, acc -> Emotions.Store.getEmotionScore(emotion) + acc
         end
       )
    |> Kernel./(length(emotions))

  end

  defp saveTweetInDatabase(tweet) do
    score = getScore(tweet)
    RTP.Database.save_tweet(tweet, score)
  end

  defp saveUserInDatabase(user) do
    RTP.Database.save_user(user)
  end


  @impl true
  def handle_cast({:tweet, tweet}, state) do
    if tweet != "{\"message\": panic}" do
      {:ok, tweet} = Poison.decode(tweet)
      saveTweetInDatabase(tweet["message"]["tweet"])
      # saveUserInDatabase(tweet["message"]["tweet"]["user"])
    end

    {:noreply, state}
  end
end