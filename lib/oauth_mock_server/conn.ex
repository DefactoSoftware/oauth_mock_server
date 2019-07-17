defmodule OauthMockServer.Conn do
  @moduledoc """
  Conn helpers based on Phoenix
  """

  defmacro __using__(_opts) do
    quote do
      import Plug.Conn
      alias Plug.Conn

      @doc """
      Sends redirect response to the given url.
      The response will be sent with the status code defined within
      the connection, via `Plug.Conn.put_status/2`. If no status
      code is set, a 302 response is sent.
      ## Examples
          iex> redirect(conn, "http://elixir-lang.org")
      """
      def redirect(conn, url) do
        html = Plug.HTML.html_escape(url)
        body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

        conn
        |> put_resp_header("location", url)
        |> send_resp(conn.status || 302, "text/html", body)
      end

      def send_resp(conn, default_status, default_content_type, body) do
        conn
        |> ensure_resp_content_type(default_content_type)
        |> send_resp(conn.status || default_status, body)
      end

      def ensure_resp_content_type(%Conn{resp_headers: resp_headers} = conn, content_type) do
        if List.keyfind(resp_headers, "content-type", 0) do
          conn
        else
          content_type = content_type <> "; charset=utf-8"
          %Conn{conn | resp_headers: [{"content-type", content_type} | resp_headers]}
        end
      end
    end
  end
end
