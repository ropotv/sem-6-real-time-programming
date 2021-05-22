defmodule Dispatcher do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start() do
    twitterService = TwitterService.start()
    usersService = UsersService.start()
    Console.log("Dispatcher was started")

    GenServer.start_link(__MODULE__, %{twitterService: twitterService, usersService: usersService}, name: __MODULE__)
  end

  def dispatch(data) do
    GenServer.cast(__MODULE__, {:dispatch, data})
  end

  def handle_cast({:dispatch, data}, state) do
    if data != "{\"message\": panic}" do
      {:ok, data} = Poison.decode(data)

      state.twitterService
      |> Tuple.to_list()
      |> Enum.at(1)
      |> GenServer.cast({:save, data["message"]["tweet"]})

      state.usersService
      |> Tuple.to_list()
      |> Enum.at(1)
      |> GenServer.cast({:save, data["message"]["tweet"]["user"]})
    end

    {:noreply, state}
  end
end