defmodule UsersService do
  use GenServer

  def start() do
    database = Database.connect("UsersDatabase", "RTP", "users", 1000, 1000)
    Console.log("Users Service was Initialized")

    GenServer.start_link(__MODULE__, %{database: database}, name: __MODULE__)
  end

  def init(arg) do
    {:ok, arg}
  end

  @impl true
  def handle_cast({:save, user}, state) do
    state.database
    |> Tuple.to_list()
    |> Enum.at(1)
    |> GenServer.cast({:save, user})

    {:noreply, state}
  end
end