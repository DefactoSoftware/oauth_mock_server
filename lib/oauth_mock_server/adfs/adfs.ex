defmodule OauthMockServer.Adfs do
  @moduledoc """
    A server that simulates ADFS responses.
  """

  use OauthMockServer.Conn

  alias OauthMockServer.Adfs.TokenHelper

  def metadata(conn), do: send_resp(conn, 200, adfs_metadata())

  def authorize(%Conn{params: %{"redirect_uri" => redirect_uri}} = conn) do
    user =
      case conn.params do
        %{"user" => user} -> user
        %{"client_id" => user} -> user
        _ -> "john_doe"
      end

    redirect(conn, "#{redirect_uri}?code=#{user}")
  end

  def authorize(conn), do: send_resp(conn, 200, "")

  def token(%Conn{params: %{"code" => "error"}} = conn), do: send_resp(conn, 503, "")

  def token(%Conn{params: %{"code" => user_name}} = conn),
    do: token_response(conn, user_name)

  defp token_response(conn, subject) do
    access_token = TokenHelper.create_access_token(%{"sub" => subject})
    send_resp(conn, 200, Jason.encode!(%{access_token: access_token}))
  end

  defp adfs_metadata do
    "keys/adfs_metadata.xml"
    |> Path.expand(:code.priv_dir(:oauth_mock_server))
    |> File.read!()
  end
end
