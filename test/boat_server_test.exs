defmodule BoatServerTest do
  use ExUnit.Case
  doctest BoatServer

  test "greets the world" do
    assert BoatServer.hello() == :world
  end
end
