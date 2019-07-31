defmodule OauthMockServer.Capp11Test do
  use ExUnit.Case, async: true

  import OauthMockServer.ConnHelper

  setup :setup_conn

  @tag path: "/capp11/oauth2/authorize?redirect_uri=example.com"
  test "redirect to redirect_uri when authorizing", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == [
             "example.com?code=john_doe@example.com"
           ]

    assert response(conn, 302)
  end

  @tag path: "/capp11/oauth2/authorize?redirect_uri=example.com&user=some_user"
  test "redirect with code based on user param if present", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == ["example.com?code=some_user"]
    assert response(conn, 302)
  end

  @tag path: "/capp11/oauth2/authorize?redirect_uri=example.com&client_id=some_client"
  test "redirect with code based on client_id param if present", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == ["example.com?code=some_client"]
    assert response(conn, 302)
  end

  @tag path: "/capp11/oauth2/token?code=some_user", method: :post
  test "returns an access_token using the code as subject", %{conn: conn} do
    assert response(conn, 200) == Jason.encode!(%{access_token: "some_user"})
  end

  @tag path: "/capp11/oauth2/token?code=token_error", method: :post
  test "returns an empty token with an error", %{conn: conn} do
    assert response(conn, 503) ==
             Jason.encode!(%{
               access_token: nil,
               error: "token_error",
               error_description: "token_error"
             })
  end

  @tag path: "/capp11/oauth2/token?code=provider_error", method: :post
  test "returns an error if token can not be retrieved", %{conn: conn} do
    assert response(conn, 503) ==
             Jason.encode!(%{error: "provider_error", error_description: "provider_error"})
  end

  @tag path: "/capp11/api/v6/accounts/me?Authorization=Bearer 1234"
  test "returns the user info", %{conn: conn} do
    assert response(conn, 200) == Jason.encode!(%{email: "1234"})
  end

  @tag path: "/capp11/api/v6/accounts/me?Authorization=Bearer unauthorized"
  test "returns an 401 status if unauthorized", %{conn: conn} do
    assert response(conn, 401)
  end

  defp adfs_metadata,
    do: "priv/keys/adfs_metadata.xml" |> Path.expand(File.cwd!()) |> File.read!()
end
