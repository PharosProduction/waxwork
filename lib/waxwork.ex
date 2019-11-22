defmodule Waxwork do
  defmacro seed(table, do: expr) do
    quote do
      table_name = unquote(table)
      table_name |> Waxwork.EntityService.create_table()

      for instance <- unquote(expr) do
        Waxwork.EntityService.create(instance)
      end
    end
  end
end
