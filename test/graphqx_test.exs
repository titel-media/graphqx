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

    {:ok,
     %{
       data: %{"monster" => :null},
       errors: [
         %{
           key: :resolver_error,
           message: "<<\"unknown query: monster\">>",
           path: ["ROOT", "monster"]
         }
       ]
     }} = Graphqx.Query.run(query)
  end
end
