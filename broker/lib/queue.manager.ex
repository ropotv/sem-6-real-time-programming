defmodule Queue.Manager do
  use GenServer

  def init(arg) do
    {:ok, arg}
  end

  def start_link() do
    manage()
    GenServer.start_link(__MODULE__, %{})
  end

  def handle_info(:manage, state) do
    if Queue.len() > 0 do
      {client, content} = Queue.get()
      Handler.send_content(client, content)
      manage()
    else
      manage()
    end

    {:noreply, state}
  end


  defp manage() do
    Process.send_after(self(), :manage, 10)
  end
end