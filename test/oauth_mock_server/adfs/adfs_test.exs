defmodule OauthMockServer.AdfsTest do
  use ExUnit.Case, async: true

  import OauthMockServer.ConnHelper

  alias OauthMockServer.Adfs.TokenHelper

  setup :setup_conn

  @tag path: "/adfs/metadata.xml"
  test "returns dummy metadata.xml", %{conn: conn} do
    assert response(conn, 200) == adfs_metadata()
  end

  @tag path: "/adfs/oauth2/authorize?redirect_uri=example.com"
  test "redirect to redirect_uri when authorizing", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == ["example.com?code=john_doe"]
    assert response(conn, 302)
  end

  @tag path: "/adfs/oauth2/authorize?redirect_uri=example.com&user=some_user"
  test "redirect with code based on user param if present", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == ["example.com?code=some_user"]
    assert response(conn, 302)
  end

  @tag path: "/adfs/oauth2/authorize?redirect_uri=example.com&client_id=some_client"
  test "redirect with code based on client_id param if present", %{conn: conn} do
    assert Plug.Conn.get_resp_header(conn, "location") == ["example.com?code=some_client"]
    assert response(conn, 302)
  end

  @tag path: "/adfs/oauth2/token?code=some_user", method: :post
  test "returns an access_token using the code as subject", %{conn: conn} do
    access_token = TokenHelper.create_access_token(%{sub: "some_user"})

    assert response(conn, 200) == Jason.encode!(%{access_token: access_token})
  end

  @tag path: "/adfs/oauth2/token?code=error", method: :post
  test "returns an error", %{conn: conn} do
    assert response(conn, 503) == ""
  end

  defp adfs_metadata,
    do: "priv/keys/adfs_metadata.xml" |> Path.expand(File.cwd!()) |> File.read!()
end
