defmodule Console do
  require Logger

  def log(message) do
    Logger.info(message)
  end
end

