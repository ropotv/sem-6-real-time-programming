defmodule Application do
  @moduledoc false


  use Application

  def start(_type, _args) do
    Application.Supervisor.start_link()
  end
end