defmodule Dispatcher do
  def init(arg) do
    {:ok, arg}
  end

  def dispatch(data) do
    if data != "{\"message\": panic}" do
      {:ok, decoded} = Poison.decode(data)
      Connector.send_topic("tweet", decoded["message"]["tweet"])
      Connector.send_topic("user", decoded["message"]["tweet"]["user"])
    end
  end
end