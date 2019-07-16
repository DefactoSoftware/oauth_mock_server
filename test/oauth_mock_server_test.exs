defmodule OauthMockServerTest do
  use ExUnit.Case, async: true

  import OauthMockServer.ConnHelper

  setup :setup_conn

  @tag path: "/"
  test "returns a 200 response with a message", %{conn: conn} do
    assert response(conn, 200) == "OauthMockServer Running"
  end
end
