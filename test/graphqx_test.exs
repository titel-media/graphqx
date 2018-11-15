defmodule GraphqxTest do
  use ExUnit.Case
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
    IO.inspect Graphqx.Query.run(query)
  end

end

