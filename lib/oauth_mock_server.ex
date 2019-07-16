defmodule OauthMockServer do
  @moduledoc """
  Documentation for OauthMockServer.
  """

  def start(_type, _args), do: Supervisor.start_link([], strategy: :one_for_one)

  def start_link(options) do
    [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: OauthMockServer.Router,
        options: [port: Keyword.get(options, :port, 54_345)]
      )
    ]
    |> Supervisor.start_link(strategy: :one_for_one, name: OauthMockServer.Supervisor)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :supervisor
    }
  end
end
