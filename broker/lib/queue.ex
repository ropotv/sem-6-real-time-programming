defmodule Queue do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link() do
    GenServer.start_link(__MODULE__, %{queue: :queue.new()}, name: __MODULE__)
  end

  def add(data) do
    GenServer.cast(__MODULE__, {:add, data})
  end

  def get() do
    GenServer.cast(__MODULE__, {:get})
  end

  def length() do
    GenServer.cast(__MODULE__, {:length})
  end

  def handle_cast({:add, data}, state) do
    queue = :queue.in(data, state.queue)
    {:noreply, %{queue: queue}}
  end

  def handle_cast({:get}, state) do
    {head, queue} = :queue.out(state.queue)
    if head == :empty do
      {:reply, nil, %{queue: queue}}
    else
      {:value, first} = head;
      {:reply, first, %{queue: queue}}
    end
  end

  def handle_cast({:length}, state) do
    {:reply, :queue.len(state.queue), state}
  end
end
