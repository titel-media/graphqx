defmodule Graphqx do
  use Application
  require Logger

  def start_phase(:load_graphql_schema, _, []) do
    with config when not is_nil(config) <- Application.get_env(:graphqx, :schema),
         {:ok, path} <- Keyword.fetch(config, :path),
         {:ok, mapping} <- Keyword.fetch(config, :mapping),
         {:ok, schema} <- File.read(path),
         :ok <- Graphql.Schema.load(schema, mapping) do
      Logger.info("Grapqhx schema successfully loaded from #{path}")
    else
      nil ->
        Logger.debug(
          "Graphqx could not load schema: No configuration provided.\nExample:\n\n  config :graphqx, :schema, path: \"priv/schema.gql\", mapping: %{ ... }"
        )

      error ->
        Logger.debug("Graphqx could not load schema: #{inspect(error)}")
    end
  end

  def start(_type, _args) do
    Task.start_link(fn -> :ok end)
  end
end
