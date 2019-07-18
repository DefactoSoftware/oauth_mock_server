defmodule OauthMockServer.CodeReloaderTest do
  use ExUnit.Case, async: true

  import ExUnit.CaptureLog

  setup do
    code_reloader = OauthMockServer.CodeReloader.start_link()
    %{code_reloader: code_reloader}
  end

  test "starts code_reloader", %{code_reloader: code_reloader} do
    assert {:ok, _} = code_reloader
  end

  test "reloads on change in the lib folder" do
    assert capture_log(fn ->
             OauthMockServer.CodeReloader.handle_info(:poll_and_reload, nil)
           end) =~ "Files changed on disk. Recompiling..."
  end

  test "does not reload when there are no changes in the lib folder" do
    Logger.remove_backend(:console)
    # Get current mtime without printing the file change log to console
    {:noreply, mtime} = OauthMockServer.CodeReloader.handle_info(:poll_and_reload, nil)
    Logger.add_backend(:console)

    refute capture_log(fn ->
             OauthMockServer.CodeReloader.handle_info(:poll_and_reload, mtime)
           end) =~ "Files changed on disk. Recompiling..."
  end
end
