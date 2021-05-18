defmodule Console do
  @moduledoc false

  def log(data) do
    IO.puts IO.ANSI.format([:yellow_background, :black, inspect(data)])
  end
end

