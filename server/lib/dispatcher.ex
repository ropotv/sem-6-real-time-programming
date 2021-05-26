defmodule Dispatcher do
  def init(arg) do
    {:ok, arg}
  end

  def dispatch(data) do
    if data != "{\"message\": panic}" do
      {:ok, decoded} = Poison.decode(data)
      Queue.add("tweet", decoded["message"]["tweet"])
      #   Queue.add("user", decoded["message"]["tweet"]["user"])
    end
  end
end