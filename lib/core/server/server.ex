defmodule RTP.Server do
  use GenServer

  def start() do
    children = [Emotions.Service.start()]
    GenServer.start_link(__MODULE__, %{children: children}, name: __MODULE__)
  end

  def init(stack) do
    {:ok, stack}
  end

  def handle_cast({:post, data}, state) do
    Enum.at(state.children, 0)
    |> Tuple.to_list()
    |> Enum.at(1)
    |> GenServer.cast({:tweet, data})

    {:noreply, state}
  end

  def post(data) do
    GenServer.cast(__MODULE__, {:post, data})
  end
end