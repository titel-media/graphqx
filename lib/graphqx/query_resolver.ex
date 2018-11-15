defmodule Graphqx.QueryResolver do

  def execute(_ctx, _obj, field, _args) do
    {:error, "unknown query: #{field}"}
  end

end
