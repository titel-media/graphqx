defmodule Graphqx.Query do
  require Logger

  def run!(document, options \\ []) do
    operation_name = Keyword.get(options, :op_name) || :undefined
    vars = Keyword.get(options, :vars) || %{}

    {:ok, fun_env, ast} = prepare_statement(document)
    params = :graphql.type_check_params(fun_env, operation_name, vars)
    context = %{params: params, operation_name: operation_name}
    :graphql.execute(context, ast)
  end

  def run(document, options \\ []) do
    operation_name = Keyword.get(options, :op_name) || :undefined
    vars = Keyword.get(options, :vars) || %{}

    try do
      case prepare_statement(document) do
        {:ok, fun_env, ast} ->
          params = :graphql.type_check_params(fun_env, operation_name, vars)
          context = %{params: params, operation_name: operation_name}
          response = :graphql.execute(context, ast)
          {:ok, response}

        error ->
          error
      end
    catch
      {:error, error_object} = error_tuple when is_map(error_object) ->
        error_tuple

      unhandled ->
        Logger.error("Graphqx.Query#run unhandled error: #{inspect(unhandled)}")
        throw(unhandled)
    end
  end

  def introspect!(schema_query) do
    %{data: %{"__schema" => data}} = run!("{ __schema { #{schema_query} } }")
    data
  end

  defp prepare_statement(document) do
    with {:ok, ast} <- :graphql.parse(document),
         elaborated <- :graphql.elaborate(ast),
         {:ok, %{fun_env: fun_env, ast: ast}} <- :graphql.type_check(elaborated),
         :ok <- :graphql.validate(ast) do
      {:ok, fun_env, ast}
    else
      {:error, {:parser_error, {_, :graphql_parser, messages}}} ->
        message = Enum.map(messages, &to_string/1) |> Enum.join("")
        {:error, %{key: "parser_error", message: message}}

      {:error, _error} = error_tuple ->
        error_tuple

      unhandled ->
        Logger.error("Graphqx.Query#prepare_statement unhandled error: #{inspect(unhandled)}")
        unhandled
    end
  end
end
