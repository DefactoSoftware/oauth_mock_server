defmodule OauthMockServer.Capp11 do
  @moduledoc """
    A server that mocks Capp11 SSO responses
  """

  use OauthMockServer.Conn

  def authorize(%Conn{params: %{"redirect_uri" => redirect_uri}} = conn) do
    user =
      case conn.params do
        %{"user" => user} -> user
        %{"client_id" => user} -> user
        _ -> "john_doe@example.com"
      end

    redirect(conn, "#{redirect_uri}?code=#{user}")
  end

  def authorize(conn), do: send_resp(conn, 200, "")

  def token(%Conn{params: %{"code" => "token_error"}} = conn),
    do: send_resp(conn, 503, token_error())

  def token(%Conn{params: %{"code" => "provider_error"}} = conn),
    do: send_resp(conn, 503, provider_error())

  def token(%Conn{params: %{"code" => user_name}} = conn),
    do: token_response(conn, user_name)

  def user_info(%Conn{params: %{"Authorization" => "Bearer unauthorized"}} = conn),
    do: unauthorized_error(conn)

  def user_info(%Conn{params: %{"Authorization" => "Bearer " <> subject}} = conn),
    do: user_response(conn, subject)

  defp token_response(conn, subject),
    do: send_resp(conn, 200, Jason.encode!(%{access_token: subject}))

  defp user_response(conn, subject),
    do: send_resp(conn, 200, Jason.encode!(%{email: subject}))

  defp token_error do
    Jason.encode!(%{access_token: nil, error: "token_error", error_description: "token_error"})
  end

  defp provider_error do
    Jason.encode!(%{error: "provider_error", error_description: "provider_error"})
  end

  defp unauthorized_error(conn), do: send_resp(conn, 401, "")
end
