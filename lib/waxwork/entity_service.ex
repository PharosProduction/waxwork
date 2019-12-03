defmodule Waxwork.EntityService do
  alias DbManager.EntityService
  alias DbManager.EntityService.Ets
  require Logger

  @behaviour EntityService
  @behaviour EntityService.Initializer

  @spec init(list({String.t, String.t | atom})) :: :ok
  def init(opts) when is_list(opts) do
    opts |> Enum.each(&init/1)
    :ok
  end

  @spec init({String.t(), String.t}) :: :ok
  def init({file, folder}) when is_bitstring(folder) do
    Path.expand(file, folder) |> Code.eval_file()
    :ok
  end

  @spec init({String.t(), atom}) :: :ok
  def init({file, application_name}) when is_atom(application_name) do
    priv_dir = :code.priv_dir(application_name)
    Path.expand(file, priv_dir) |> Code.eval_file()
    :ok
  end

  defdelegate create_table(table), to: Ets
  defdelegate create(entity), to: Ets
  defdelegate update(entity), to: Ets
  defdelegate delete(table, id), to: Ets
  defdelegate get(table, id), to: Ets
  defdelegate get_all(table, pattern \\ []), to: Ets
end
