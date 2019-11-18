defmodule Waxwork do
  alias Waxwork.Server

  @spec seed_file(String.t()) :: :ok
  def seed_file(file) do
    Server.seed_file(file)
  end

  @spec seed_file(String.t(), String.t()) :: :ok
  def seed_file(file, relative_to) when is_bitstring(relative_to) do
    Server.seed_file(file, relative_to)
  end

  @spec seed_file(String.t(), atom) :: :ok
  def seed_file(file, application_name) when is_atom(application_name) do
    Server.seed_file(file, application_name)
  end

  @spec get_table(atom) :: {:ok, [struct]}
  def get_table(table) do
    Server.get_table(table)
  end

  defmacro seed(table, do: expr) do
    quote do
      table_name = unquote(table)
      table_name |> Server.create_table()

      for instance <- unquote(expr) do
        Server.insert(table_name, instance)
      end
    end
  end
end
