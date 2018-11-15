defmodule Graphqx.DefaultScalarResolver do
  require Logger

  def input(type, value) do
    Logger.warn("Graphx.DefaultScalarResolver unmatched input #{inspect(type)} -> #{inspect(value)}")
    {:ok, value}
  end

  def output(type, value) do
    Logger.warn("Graphx.DefaultScalarResolver unmatched output #{inspect(type)} -> #{inspect(value)}")
    {:ok, value}
  end
end

