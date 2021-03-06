defmodule RTP.Supervisor do
  @moduledoc false

  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def init(arg) do
    children = [
      worker(RTP.Server, [arg], restart: :temporary)
    ]

    supervise(children, strategy: :one_for_one)
  end
end