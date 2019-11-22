defmodule WaxworkTest do
  alias TestEntity
  use ExUnit.Case
  doctest Waxwork

  test "can get table" do
  #  {:ok, items} = DbManager.get_all(TestEntity)
  #  assert items |> Enum.count() == 7
  end
end
