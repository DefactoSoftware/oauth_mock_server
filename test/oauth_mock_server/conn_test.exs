defmodule OauthMockServer.ConnTest do
  use ExUnit.Case, async: true
  use OauthMockServer.Conn

  # import OauthMockServer.ConnHelper
  use Plug.Test

  setup do
    %{conn: conn(:get, "/")}
  end

  test "redirects to an external url", %{conn: conn} do
    assert %{
             resp_body:
               "<html><body>You are being <a href=\"example.com\">redirected</a>.</body></html>",
             resp_headers: [
               {"content-type", "text/html; charset=utf-8"},
               {"cache-control", _},
               {"location", "example.com"}
             ],
             status: 302
           } = redirect(conn, "example.com")
  end
end
