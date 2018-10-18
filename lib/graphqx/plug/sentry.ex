defmodule Graphqx.Plug.Sentry do
  def sentry_body_scrubber(%{body_params: body_params} = conn) when is_map(body_params) do
    Sentry.Plug.default_body_scrubber(conn)
    |> Map.merge(body_params)
  end

  def sentry_body_scrubber(conn), do: Sentry.Plug.default_body_scrubber(conn)
end
