defmodule Console do
  require Logger

  def log(data) do
    Logger.info(data)
  end

  def warn(data) do
    Logger.warning(data)
  end
end

