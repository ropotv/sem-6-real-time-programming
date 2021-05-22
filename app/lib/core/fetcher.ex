defmodule Fetcher do
  def init(url) do
    EventsourceEx.new(url, stream_to: self())
    loopFetch()
  end

  def loopFetch() do
    receive do
      body -> Server.post(body.data)
    end
    loopFetch()
  end
end