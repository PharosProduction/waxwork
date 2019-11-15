defmodule Waxwork do
  alias Waxwork.Server

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
