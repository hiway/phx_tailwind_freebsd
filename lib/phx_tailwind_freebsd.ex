defmodule PhxTailwindFreebsd do
  @moduledoc """
  Workaround to install Tailwind binary on FreeBSD.

  Add `phx_tailwind_freebsd` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:phx_tailwind_freebsd, "~> 0.1.2", runtime: Mix.env() == :dev}
    ]
  end
  ```

  Run `mix tailwind.install_freebsd` in the project directory.
  """

  def tailwind_maybe_freebsd() do
    case :os.type() do
      {:unix, :freebsd} ->
        version = version()

        if !cache_exists?(version) do
          Mix.shell().info("Downloading Tailwind binary for FreeBSD")
          download_to_cache(version)
        end
        if !cache_sha256_verify?(version) do
          Mix.shell().error("SHA256 mismatch for downloaded Tailwind binary")
          File.rm!(cached_binary_path(version))

          Mix.shell().info("Downloading Tailwind binary for FreeBSD")
          download_to_cache(version)
        end

        copy_from_cache(version)

        install(tailwind_freebsd_url(version))

      _ ->
        install()
    end
  end

  defp copy_from_cache(version) do
    File.copy!(cached_binary_path(version), build_binary_path(version))
    File.chmod!(build_binary_path(version), 0o755)
  end

  defp download_to_cache(version) do
    System.cmd("fetch", [tailwind_freebsd_url(version), "-o", cached_binary_path(version)],
      into: IO.stream()
    )
  end

  defp cache_sha256_verify?(version) do
    {output, _code} = System.cmd("fetch", [tailwind_freebsd_sha256_url(version), "-q", "-o", "-"])
    published_sha256 = String.trim(output) |> String.split(" = ") |> List.last()
    downloaded_sha256 = :crypto.hash(:sha256, File.read!(cached_binary_path(version)))
    downloaded_sha256 = Base.encode16(downloaded_sha256, case: :lower)
    published_sha256 == downloaded_sha256
  end

  defp cache_exists?(version) do
    File.exists?(cached_binary_path(version))
  end

  defp cached_binary_path(version) do
    Path.join(cache_dir(), "tailwind-freebsd-x64-#{version}")
  end

  defp build_binary_path(_version) do
    Mix.Project.build_path()
    # one level out of "dev" directory
    |> Path.dirname()
    |> Path.join("tailwind-freebsd-x64")
  end

  defp cache_dir() do
    cache_dir = :filename.basedir(:user_cache, "tailwind_freebsd")
    File.mkdir_p!(cache_dir)
    cache_dir
  end

  defp version() do
    Config.Reader.read!("./config/config.exs", env: :dev) |> get_in([:tailwind, :version])
  end

  defp tailwind_freebsd_url(version) do
    "https://people.freebsd.org/~dch/pub/tailwind/v#{version}/tailwindcss-freebsd-x64"
  end

  defp tailwind_freebsd_sha256_url(version) do
    "https://people.freebsd.org/~dch/pub/tailwind/v#{version}/tailwindcss-freebsd-x64.sha256"
  end

  defp install() do
    Mix.Task.run("tailwind.install", ["--if-missing"])
  end

  defp install(source) do
    Mix.Task.run("tailwind.install", [
      "--if-missing",
      source
    ])
  end
end
