defmodule BoatServer do
  @moduledoc """
  Documentation for BoatServer.
  """
  @signalk Application.get_env(:boat_server, :signalk)

  @doc """
  Hello world.

  ## Examples

      iex> BoatServer.hello()
      :world

  """
  def hello do
    :world
  end

  def start() do
    @signalk[:hosts]
    |> Enum.map(fn x -> BoatServer.Signalk.observe(x) end)
  end
end
