defmodule Graphqx.Schema do
  @moduledoc """
  Load a schema into Graphqx. You can only load one schema for a whole application instance.
  """

  @default_scalar_resolver %{default: Graphqx.DefaultScalarResolver}
  @default_resolver %{default: Graphqx.ObjectResolver}
  @default_object_resolvers %{
    default: Graphqx.ObjectResolver,
    Query: Graphqx.QueryResolver,
    Mutation: Graphqx.MutationResolver
  }

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      require Logger
      @otp_app Keyword.fetch!(opts, :otp_app)

      def load() do
        with config when not is_nil(config) <- Application.get_env(@otp_app, __MODULE__),
             {:ok, filename} <- Keyword.fetch(config, :filename),
             mapping <-
               Keyword.get(config, :mapping, %{}) |> Graphqx.Schema.merge_default_mappings(),
             path <- Path.join(:code.priv_dir(@otp_app), filename),
             {:ok, schema} <- File.read(path),
             :ok <- Graphqx.Schema.load(schema, mapping) do
          Logger.info("Grapqhx schema loaded from #{path}")
        else
          nil ->
            Logger.debug(
              "Graphqx could not load schema: No configuration provided.\nExample:\n\n  config :graphqx, :schema, path: \"priv/schema.gql\", mapping: %{ ... }"
            )

          error ->
            Logger.debug("Graphqx could not load schema: #{inspect(error)}")
        end
      end

      :ok
    end
  end

  @doc """
  Load a schema, inserts the root definition and validates everything.
  """
  def load(content, mapping_rules) do
    :ok = :graphql.load_schema(mapping_rules, content)
  end

  @doc false
  def merge_default_mappings(mapping) do
    scalars = Map.merge(@default_scalar_resolver, Map.get(mapping, :scalars, %{}))
    interfaces = Map.merge(@default_resolver, Map.get(mapping, :interfaces, %{}))
    unions = Map.merge(@default_resolver, Map.get(mapping, :unions, %{}))
    objects = Map.merge(@default_object_resolvers, Map.get(mapping, :objects, %{}))

    Map.merge(mapping, %{
      scalars: scalars,
      interfaces: interfaces,
      unions: unions,
      objects: objects
    })
  end
end
