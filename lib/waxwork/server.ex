defmodule Waxwork.Server do
  use GenServer

  alias :ets, as: Ets

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create_table(table) do
    Ets.new(table, [:set, :protected, :named_table])
  end

  def insert(table, instance) do
    data = instance |> Map.values() |> List.to_tuple() |> Tuple.delete_at(0)
    Ets.insert_new(table, data)
  end

  def get_table(table) do
    result =
      Ets.tab2list(table)
      |> Enum.map(&struct(table, &1))

    {:ok, result}
  end

  # Server
  @impl true
  def init(_opts) do
    Path.expand(
      Application.get_env(:waxwork, :seed_file),
      :code.priv_dir(Application.get_env(:waxwork, :application_name))
    )
    |> Code.eval_file()

    {:ok, nil}
  end
end
