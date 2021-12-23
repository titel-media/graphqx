defmodule Graphqx.MixProject do
  use Mix.Project

  def project do
    [
      app: :graphqx,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :graphql
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # plug is our web layer
      {:plug, "~> 1.6"},
      # this is the erlang graphql library providing query parsing and object resolvers
      {:graphql, git: "https://github.com/jlouis/graphql-erlang.git", ref: "4fd356294c2acea42a024366bc5a64661e4862d7"},
      {:poison, "~> 5.0"},
      # ex_doc is generating documentation for us
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
