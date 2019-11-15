defmodule Waxwork do
  alias Waxwork.Server

  def get_table(table) do
    Server.get_table(table)
  end

  defmacro seed(table, do: expr) do
    quote do
      unquote(table) |> Server.create_table()

      for instance <- unquote(expr) do
        Server.insert_new(tabble, data)
      end
    end
  end
end
