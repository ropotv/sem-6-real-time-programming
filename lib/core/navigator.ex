defmodule Navigator do
  use GenServer

  def start() do
    children = []

    GenServer.start_link(__MODULE__, %{index: 0, children: children}, name: __MODULE__)
  end

  def navigate(body) do
    GenServer.cast(__MODULE__, {:route, body.data})
  end

  def init(state) do
    {:ok, state}
  end

  def handle_cast({:route, tweet}, state) do
    Enum.at(state.children, rem(state.index, 3))
    |> Tuple.to_list()
    |> Enum.at(1)
    |> GenServer.cast({:compute, tweet})

    {:noreply, %{index: state.index + 1, children: state.children}}
  end
end