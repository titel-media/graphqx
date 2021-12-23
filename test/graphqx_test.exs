defmodule GraphqxTest do
  use ExUnit.Case, async: true
  doctest Graphqx

  test "foo" do
    query = """
    {
      monster(id: "foo") {
        id
        name
      }
    }
    """
    IO.inspect Graphqx.Query.run(query, op_name: nil, vars: nil)
  end

end

