defmodule BoatServer do
  @moduledoc """
  Documentation for BoatServer.
  """
  @signalk Application.get_env(:boat_server, :signalk)

  def start() do
    @signalk[:hosts]
    |> Enum.map(fn x -> BoatServer.Signalk.observe(x) end)
  end
end
