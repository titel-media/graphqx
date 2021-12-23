
Code.require_file("test/example/schema.ex")
Application.put_env(:graphqx, Example.Schema, filename: "example.gql")
Example.Schema.load()

ExUnit.start()
