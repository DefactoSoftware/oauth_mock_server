defmodule OauthMockServer.Router do
  @moduledoc """
    A lightweight server used in tests to mock actual web requests
  """

  use Plug.Router

  alias OauthMockServer.Adfs
  alias OauthMockServer.Capp11

  plug(OauthMockServer.RequestLogger)

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["text/*"],
    json_decoder: Jason
  )

  plug(:match)
  plug(:dispatch)

  # Status
  get("/", do: Plug.Conn.send_resp(conn, 200, "OauthMockServer Running"))

  # ADFS
  get("/adfs/metadata.xml", do: Adfs.metadata(conn))
  get("/adfs/oauth2/authorize", do: Adfs.authorize(conn))
  options("/adfs/oauth2/authorize", do: Adfs.authorize(conn))
  post("/adfs/oauth2/token", do: Adfs.token(conn))

  # CAPP11
  get("/capp11/oauth2/authorize", do: Capp11.authorize(conn))
  options("/capp11/oauth2/authorize", do: Capp11.authorize(conn))
  post("/capp11/oauth2/token", do: Capp11.token(conn))
  get("/capp11/api/v6/accounts/me", do: Capp11.user_info(conn))
end
