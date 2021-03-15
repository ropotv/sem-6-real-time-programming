defmodule HttpClient do
  def fetch() do
    receive do
      tweet ->
        RTP.Server.post(tweet.data)
        fetch()
    end
  end

  def init(url) do
    EventsourceEx.new(url, stream_to: self())
    fetch()
  end
end