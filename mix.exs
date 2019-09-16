defmodule OauthMockServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :oauth_mock_server,
      version: "0.1.1",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      # Docs
      name: "OauthMockServer",
      description: "Simple server that returns dummy responses for testing OAuth, OpenID and SSO",
      package: [
        links: %{
          "GitHub" => "https://github.com/DefactoSoftware/oauth_mock_server",
          "Defacto Software" => "https://www.defacto.nl"
        },
        maintainers: ["Kuret"],
        licenses: ["MIT"]
      ],
      # The main page in the docs
      docs: [main: "readme", extras: ["README.md"]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy, :plug, :poison],
      mod: {OauthMockServer, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.1"},
      {:joken, "~> 1.5.0"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
