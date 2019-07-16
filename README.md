# OauthMockServer

**Server for mocking OAuth/SSO requests using predefined responses**
Currently, only mocks ADFS SSO responses with barebones data

Supported endpoint:
- `/adfs/metadata.xml`: Returns a barebones metadata.xml with only the public signing certificate node present
- `/adfs/oauth2/authorize`: Returns an empty `200` response
- `/adfs/oauth2/token?code={value}`: Returns an encoded `{"sub" => "value"}` claim in a JWT, where the value is euqal to the `code` param

Claims can be decoded with the public signing certificate

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
      git: "https://github.com/DefactoSoftware/oauth_mock_server.git", only: [:dev, :test]}
  ]
end
```
