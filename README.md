# OauthMockServer

**Server for mocking OAuth/SSO requests using predefined responses**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `oauth_mock_server` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:oauth_mock_server, "~> 0.1.0"}
  ]
end
```

Otherwise:

```elixir
def deps do
  [
    {:oauth_mock_server,
      git: "https://github.com/DefactoSoftware/oauth_mock_server.git", only: [:dev. :test]}
  ]
end
```
