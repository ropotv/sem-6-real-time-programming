defmodule Fetcher do
  def init(url) do
    EventsourceEx.new(url, stream_to: self())
    loop_fetch()
  end

  def loop_fetch() do
    receive do
      res -> Queue.add(res.data)
             loop_fetch()
    end
  end
end