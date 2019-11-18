defmodule Waxwork.Server do
  use GenServer
  require Logger

  alias :ets, as: Ets

  # Client
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def create_table(table) do
    Ets.new(table, [:bag, :protected, :named_table])
  end

  def insert(table, instance) do
    data =
      instance
      |> Map.values()
      |> List.to_tuple()
      |> Tuple.delete_at(0)
      |> Tuple.insert_at(0, UUID.uuid4())

    Ets.insert_new(table, data)
  end

  def get_table(table) do
    raw_result = table |> Ets.tab2list()

    result =
      raw_result
      |> Enum.map(&assemble_struct(table, &1))

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

  defp assemble_struct(table_name, item) do
    keys = Map.keys(struct(table_name))
    values = item |> Tuple.delete_at(0) |> Tuple.to_list()
    struct(table_name, Enum.zip(keys, values))
  end
end
