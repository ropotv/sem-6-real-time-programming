defmodule Dispatcher do
  def init(arg) do
    {:ok, arg}
  end

  def dispatch(data) do
    if data != "{\"message\": panic}" do
      {:ok, data} = Poison.decode(data)
      Broker.sendPacket("tweet", data["message"]["tweet"])
      Broker.sendPacket("user", data["message"]["tweet"]["user"])
    end
  end
end