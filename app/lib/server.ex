defmodule Server do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start() do
    twitterService = TwitterService.start()
    usersService = UsersService.start()
    Console.log("Server was started")

    GenServer.start_link(__MODULE__, %{twitterService: twitterService, usersService: usersService}, name: __MODULE__)
  end

  def post(data) do
    GenServer.cast(__MODULE__, {:post, data})
  end

  def handle_cast({:post, data}, state) do
    if data != "{\"message\": panic}" do
      {:ok, data} = Poison.decode(data)

      state.twitterService
      |> Tuple.to_list()
      |> Enum.at(1)
      |> GenServer.cast({:save, data["message"]["tweet"]})

      state.usersService
      |> Tuple.to_list()
      |> Enum.at(1)
      |> GenServer.cast({:save, data["message"]["tweet"]})
    end

    {:noreply, state}
  end
end