defmodule OauthMockServer.AdfsTest do
  use ExUnit.Case, async: true

  import OauthMockServer.ConnHelper

  alias OauthMockServer.Adfs
  alias OauthMockServer.Adfs.TokenHelper

  setup :setup_conn

  @tag path: "/adfs/metadata.xml"
  test "returns dummy metadata.xml", %{conn: conn} do
    assert response(conn, 200) == Adfs.valid_metadata()
  end

  @tag path: "/adfs/oauth2/authorize"
  test "returns a dummy 200 response when authorizing", %{conn: conn} do
    assert response(conn, 200) == ""
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
end
