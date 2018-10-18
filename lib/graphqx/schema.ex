defmodule Graphqx.Schema do
  @moduledoc """
  Load a schema into Graphqx. You can only load one schema for a whole application instance.
  """

  @doc """
  Load a schema, inserts the root definition and validates everything.
  """
  def load(content, mapping_rules) do
    :ok = :graphql.load_schema(mapping_rules, content)
    :ok
  end
end
