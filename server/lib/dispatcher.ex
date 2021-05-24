defmodule Dispatcher do
  def init(arg) do
    {:ok, arg}
  end

  def dispatch(data) do
    if data != "{\"message\": panic}" do
      {:ok, data} = Poison.decode(data)
      Connector.send_packet("tweet", data["message"]["tweet"])
      Connector.send_packet("user", data["message"]["tweet"]["user"])
    end
  end
end