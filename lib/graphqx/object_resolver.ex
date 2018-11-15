defmodule Graphqx.ObjectResolver do

  def execute(_ctx, obj, field, _args) when is_map(obj) do
    {:ok, Map.get(obj, field)}
  end

  def execute(_ctx, obj, field, _args) do
    {:error, :unmatched_resolver}
  end

end

