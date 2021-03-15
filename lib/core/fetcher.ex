defmodule Fetcher do
  def fetch() do
    receive do
      data ->
        Navigator.navigate(data)
        fetch()
    end
  end

  def init(url) do
    EventsourceEx.new(url, stream_to: self())
    fetch()
  end
end