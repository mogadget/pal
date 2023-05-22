defmodule PalTest do
  use ExUnit.Case
  doctest Pal

  test "greets the world" do
    assert Pal.hello() == :world
  end
end
