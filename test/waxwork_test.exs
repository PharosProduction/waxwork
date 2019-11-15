defmodule WaxworkTest do
  use ExUnit.Case
  doctest Waxwork

  test "greets the world" do
    assert Waxwork.hello() == :world
  end
end
