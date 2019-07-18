defmodule OauthMockServer.ConnHelper do
  @moduledoc "Helper functions for testing with conn"

  use Plug.Test

  alias OauthMockServer.Router

  @opts Router.init([])

  def setup_conn(%{path: path, method: method}), do: [conn: build_conn(path, method)]
  def setup_conn(%{path: path}), do: [conn: build_conn(path)]
  def setup_conn(_), do: [conn: build_conn("/")]

  def response(%{state: :sent, status: conn_status, resp_body: body}, status)
      when conn_status == status,
      do: body

  def response(_, _), do: false

  defp build_conn(route, method \\ :get) do
    method
    |> conn(route)
    |> Router.call(@opts)
  end
end
