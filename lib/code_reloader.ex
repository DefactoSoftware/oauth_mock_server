defmodule OauthMockServer.CodeReloader do
  @moduledoc "Hot reloading of code in the lib folder"

  use GenServer
  alias Mix.Tasks.Compile.Elixir, as: ExCompile

  def start_link do
    Process.send_after(__MODULE__, :poll_and_reload, 5000)
    GenServer.start_link(__MODULE__, %{}, name: OauthMockServer.CodeReloader)
  end

  def init(args), do: {:ok, args}

  def handle_info(:poll_and_reload, state) do
    current_mtime = get_current_mtime("lib")
    handle_path("lib", current_mtime, state)

    Process.send_after(__MODULE__, :poll_and_reload, 3000)
    {:noreply, current_mtime}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  defp handle_path(path, current_mtime, current_mtime), do: {path, current_mtime}

  defp handle_path(path, current_mtime, _) do
    ExCompile.run(["--ignore-module-conflict"])
    {path, current_mtime}
  end

  defp get_current_mtime(dir) do
    case File.ls(dir) do
      {:ok, files} -> get_current_mtime(files, [], dir)
      _ -> nil
    end
  end

  defp get_current_mtime([], mtimes, _cwd) do
    mtimes |> Enum.sort() |> Enum.reverse() |> List.first()
  end

  defp get_current_mtime([h | tail], mtimes, cwd) do
    mtime =
      case File.dir?("#{cwd}/#{h}") do
        true -> get_current_mtime("#{cwd}/#{h}")
        false -> File.stat!("#{cwd}/#{h}").mtime
      end

    get_current_mtime(tail, [mtime | mtimes], cwd)
  end
end
