defmodule Mix.Tasks.Server do
  @shortdoc "Starts the mock server"
  @moduledoc false

  use Mix.Task

  alias Mix.Tasks.Run, as: MixTask

  @doc false
  def run(args) do
    port = Application.get_env(:oauth_mock_server, :port, 54_345)

    {:ok, _} = Application.ensure_all_started(:logger)
    {:ok, _} = Application.ensure_all_started(:cowboy)

    OauthMockServer.start_link(port: port)
    Mix.shell().info("OauthMockServer started at port #{port}")

    OauthMockServer.CodeReloader.start_link()

    MixTask.run(run_args() ++ args)
  end

  defp run_args do
    if iex_running?(), do: [], else: ["--no-halt"]
  end

  defp iex_running? do
    Code.ensure_loaded?(IEx) and IEx.started?()
  end
end
