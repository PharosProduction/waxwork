defmodule TestEntity do
  defstruct [:value, :token, id: 0, prop_3: 0, prop_4: 0, prop_5: 0, prop_6: 0]
end

defmodule WaxworkTest do
  use ExUnit.Case
  doctest Waxwork

  setup do
    Waxwork.seed_file("test_seed.exs", "./test/")
  end

  test "can get table" do
    {:ok, items} = Waxwork.get_table(TestEntity)
    assert items |> Enum.count() == 7
  end
end
