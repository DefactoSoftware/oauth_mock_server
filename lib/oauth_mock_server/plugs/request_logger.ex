defmodule OauthMockServer.RequestLogger do
  require Logger

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    if Mix.env() != :test, do: register_logger(conn), else: conn
  end

  defp register_logger(conn) do
    start_time = System.monotonic_time()

    Plug.Conn.register_before_send(conn, fn conn ->
      Logger.log(:info, fn ->
        redirect = Plug.Conn.get_resp_header(conn, "location")
        redirect_string = (redirect != [] && "\nRedirected: #{redirect}") || ""

        stop_time = System.monotonic_time()
        time_us = System.convert_time_unit(stop_time - start_time, :native, :microsecond)
        time_ms = div(time_us, 100) / 10

        """
        #{conn.status} #{conn.method} #{conn.request_path} (#{time_ms}ms)
        Params: #{inspect(conn.params)}#{redirect_string}
        """
      end)

      conn
    end)
  end
end
