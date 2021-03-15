defmodule Emotions.Helper do
  use GenServer

  def start(index) do
    GenServer.start_link(__MODULE__, :ok, name: {:global, index})
  end

  def compute(body) do
    GenServer.cast(__MODULE__, {:compute, body})
  end

  @impl true
  def init(:ok) do
    {:ok, %{}}
  end

  def getScore(data) do
    emotions = data["message"]["tweet"]["text"]
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


  @impl true
  def handle_cast({:compute, data}, _) do
    {:ok, tweet} = Poison.decode(data)
    IO.puts("Score is = " <> Float.to_string(getScore(tweet)))
    {:noreply, data}
  end
end