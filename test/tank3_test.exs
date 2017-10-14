defmodule TankTest do
  use ExUnit.Case
  doctest Tank

  test "greets the world" do
    assert Tank.hello() == :world
  end
end
