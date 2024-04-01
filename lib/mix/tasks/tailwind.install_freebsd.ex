defmodule Mix.Tasks.Tailwind.InstallFreebsd do
  @moduledoc """
  Workaround to install Tailwind binary on FreeBSD.
  """
  use Mix.Task

  @doc """
  Install Tailwind binary for FreeBSD.
  """
  def run(_) do
    case :os.type() do
      {:unix, :freebsd} ->
        version =
          Config.Reader.read!("./config/config.exs", env: :dev) |> get_in([:tailwind, :version])

        Mix.Task.run("tailwind.install", [
          "--if-missing",
          "https://people.freebsd.org/~dch/pub/tailwind/v#{version}/tailwindcss-freebsd-x64"
        ])

      _ ->
        Mix.Task.run("tailwind.install", ["--if-missing"])
    end
  end
end
