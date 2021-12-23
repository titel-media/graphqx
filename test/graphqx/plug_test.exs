defmodule Graphqx.PlugTest do
  use ExUnit.Case, async: true
  use Plug.Test

  test "passes the provided graphql request" do
    request = %{
      operation_name: "Test",
      query: """
         query Test($slug : ID!) {
           post(slug: $slug) {
             ... on Post { published }
             ... on Body {
               id
               parent_id
               role
             }
           }
         }
      """,
      variables: %{"slug" => "bounty-hunter-digital-camo-stool"}
    }

    res = conn(:post, "/", request) |> Graphqx.Plug.call(%{})
    assert res.status == 200
    assert {:ok, _json} = Poison.decode(res.resp_body)
  end

  test "responds with status 400 and a helpful message on syntax errors" do
    request = %{
      operation_name: "Test",
      query: """
         query Test($slug : ID!) {
           post(slug: $slug) {
              ... Post {
           }
         }
      """,
      variables: %{"slug" => "bounty-hunter-digital-camo-stool"}
    }

    res = conn(:post, "/", request) |> Graphqx.Plug.call(%{})
    assert res.status == 400

    assert %{
             "error" => %{
               "key" => "parser_error",
               "message" => "syntax error before: '{'"
             }
           } = Poison.decode!(res.resp_body)
  end

  test "responds with status 400 and a helpful message on invalid params" do
    request = %{
      operation_name: "Test",
      query: """
         query Test($slug : ID!) {
           post(slug: $slug) {
              ... on Post { slug }
           }
         }
      """,
      variables: %{"thug" => "life"}
    }

    res = conn(:post, "/", request) |> Graphqx.Plug.call(%{})
    assert res.status == 400

    assert %{
             "error" => %{
               "error_term" => "missing_non_null_param",
               "phase" => "type_check",
               "path" => ["Test", "slug"]
             }
           } = Poison.decode!(res.resp_body)
  end

  test "responds with status 400 on unknown fields" do
    request = %{
      query: """
        query ArticleQuery($slug:ID!) {
          article: post(slug: $slug) {
            ... on Post {
              unknown_field_on_post
            }
          }
        }
      """,
      variables: %{
        slug: "band-of-outsiders-longest-show-ever-fashion-show"
      }
    }

    res = conn(:post, "/", request) |> Graphqx.Plug.call(%{})
    assert res.status == 400

    assert %{
             "error" => %{
               "error_term" => "unknown_field",
               "phase" => "type_check",
               "path" => ["ArticleQuery", "post", "...", "unknown_field_on_post"]
             }
           } = Poison.decode!(res.resp_body)
  end
end
