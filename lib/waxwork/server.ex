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

    Logger.debug("Seeding #{inspect(table)}: #{inspect(data)}")

    Ets.insert_new(table, data)
  end

  def get_table(table) do
    raw_result = table |> Ets.tab2list()

    result =
      raw_result
      |> Enum.map(&assemble_struct(table, &1))

    {:ok, result}
  end

  def seed_file(file) do
    Path.expand(file)

    :ok
  end

  def seed_file(file, relative_to) when is_bitstring(relative_to) do
    Path.expand(file, relative_to) |> Code.eval_file()

    :ok
  end

  def seed_file(file, application_name) when is_atom(application_name) do
    priv_dir = :code.priv_dir(application_name)
    Path.expand(file, priv_dir) |> Code.eval_file()

    :ok
  end

  # Server
  @impl true
  def init(_opts) do
    {:ok, nil}
  end

  defp assemble_struct(table_name, item) do
    keys = Map.keys(struct(table_name))
    values = item |> Tuple.delete_at(0) |> Tuple.to_list()
    struct(table_name, Enum.zip(keys, values))
  end
end
