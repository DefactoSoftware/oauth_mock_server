defmodule OauthMockServer.Router do
  @moduledoc """
    A lightweight server used in tests to mock actual web requests
  """

  use Plug.Router

  alias OauthMockServer.Adfs

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
end
