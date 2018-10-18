defmodule Graphqx.Introspection do
  @moduledoc """
  Helper module to provide common introspections into your graphql schema.
  """

  @doc """
  Get a list of object types defined in your schema.
  """
  def objects do
    %{"types" => data} = Graphql.Query.introspect!("types { name, kind }")

    Enum.reduce(data, [], fn
      %{"kind" => "OBJECT", "name" => <<"__"::binary, _::binary>>}, acc ->
        acc

      %{"kind" => "OBJECT", "name" => name}, acc ->
        [name | acc]

      _, acc ->
        acc
    end)
  end
end
