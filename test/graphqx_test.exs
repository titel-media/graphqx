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

    assert {:ok,
     %{
       data: %{"monster" => :null},
       errors: [
         %{
           extensions: %{code: :resolver_error},
           message: "<<\"unknown query: monster\">>",
           path: ["monster"]
         }
       ]
     }} == Graphqx.Query.run(query)
  end
end
