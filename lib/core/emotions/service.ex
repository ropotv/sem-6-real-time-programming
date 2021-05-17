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
    emotions = tweet["message"]["tweet"]["text"]
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

  defp saveInDatabase(tweet) do
    RTP.Database.save_tweet(tweet)
  end


  @impl true
  def handle_cast({:tweet, tweet}, state) do
    if tweet != "{\"message\": panic}" do
      {:ok, tweet} = Poison.decode(tweet)
      #   IO.puts("Score is = " <> Float.to_string(getScore(tweet["message"]["tweet"])))
      saveInDatabase(tweet["message"]["tweet"])
    end

    {:noreply, state}
  end
end