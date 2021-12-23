defmodule Graphqx.MutationResolver do
  def execute(_ctx, _obj, field, _args) do
    {:error, "unknown mutation: #{field}"}
  end
end
