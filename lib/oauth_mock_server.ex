defmodule OauthMockServer do
  @moduledoc """
  Documentation for OauthMockServer.
  """

  use Application

  def start(_type, _args) do
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: OauthMockServer.Router,
        options: [port: Application.get_env(:oauth_mock_server, :port)]
      )
    ]

    opts = [strategy: :one_for_one, name: OauthMockServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
