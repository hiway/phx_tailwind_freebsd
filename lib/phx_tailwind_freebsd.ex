defmodule PhxTailwindFreebsd do
  @moduledoc """
  Workaround to install Tailwind binary on FreeBSD.

  Add `phx_tailwind_freebsd` to your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [
      {:phx_tailwind_freebsd, "~> 0.2.1", runtime: Mix.env() == :dev}
    ]
  end
  ```

  Run `mix tailwind.install_freebsd` in the project directory.
  """

  def install_tailwind_on_freebsd() do
    case :os.type() do
      {:unix, :freebsd} ->
        version = version()

        if is_installed?(version) do
          if is_installed_binary_verified?(version) do
            Mix.shell().info("Tailwind for FreeBSD is already installed.")
          else
            Mix.shell().error("SHA256 mismatch for installed Tailwind binary.")

            if is_cached?(version) do
              Mix.shell().info("Using cached Tailwind binary.")
              install_from_cache(version, 3)
            else
              download_and_install_from_cache(version)
            end
          end
        else
          if is_cached?(version) do
            Mix.shell().info("Using cached Tailwind binary.")
            install_from_cache(version, 3)
          else
            download_and_install_from_cache(version)
          end
      end

      _ ->
        install()
    end
  end

  defp download_and_install_from_cache(version) do
    Mix.shell().info("Downloading Tailwind for FreeBSD, this may take a while.")
    download_to_cache(version, 3)
    install_from_cache(version, 3)
    install(tailwind_freebsd_url(version))
    Mix.shell().info("Tailwind for FreeBSD installed.")
end

  defp install_from_cache(version, retries) do
    retries = exit_if_retries_exceeded(retries)

    if !is_cached_binary_verified?(version) do
      Mix.shell().error("SHA256 mismatch for downloaded Tailwind binary.")
      File.rm!(cached_binary_path(version))
      download_to_cache(version, retries)
    end

    File.copy!(cached_binary_path(version), installed_binary_path(version))
    File.chmod!(installed_binary_path(version), 0o755)

    if !is_installed_binary_verified?(version) do
      Mix.shell().error("SHA256 mismatch for installed Tailwind binary.")
      File.rm!(installed_binary_path(version))
      install_from_cache(version, retries)
    end
  end

  defp download_to_cache(version, retries) do
    retries = exit_if_retries_exceeded(retries)
    System.cmd("fetch", [tailwind_freebsd_url(version), "-o", cached_binary_path(version)])

    if !is_cached_binary_verified?(version) do
      Mix.shell().error("SHA256 mismatch for downloaded Tailwind binary.")
      File.rm!(cached_binary_path(version))
      download_to_cache(version, retries)
    end
  end

  defp exit_if_retries_exceeded(retries) do
    if retries <= 0 do
      Mix.shell().error("Retries exceeded, exiting.")
      System.halt(1)
    else
      retries - 1
    end
  end

  defp is_cached?(version) do
    File.exists?(cached_binary_path(version))
  end

  defp is_installed?(version) do
    File.exists?(installed_binary_path(version))
  end

  defp is_cached_binary_verified?(version) do
    published_sha256 = published_sha256(version)
    downloaded_sha256 = cached_binary_sha256(version)
    published_sha256 == downloaded_sha256
  end

  defp is_installed_binary_verified?(version) do
    published_sha256 = published_sha256(version)
    installed_sha256 = installed_binary_sha256(version)
    published_sha256 == installed_sha256
  end

  defp published_sha256(version) do
    if !File.exists?(cached_sha256_path(version)) do
      download_published_sha256_to_cache(version)
    end

    File.read!(cached_sha256_path(version))
  end

  defp download_published_sha256_to_cache(version) do
    {output, code} =
      System.cmd("fetch", [tailwind_freebsd_sha256_url(version), "-q", "-o", "-"])

    if code != 0 do
      Mix.shell().error("Failed to download published SHA256.")
      System.halt(1)
    end

    published_sha256 = String.trim(output) |> String.split(" = ") |> List.last()
    File.write!(cached_sha256_path(version), published_sha256)
  end

  defp cached_binary_sha256(version) do
    :crypto.hash(:sha256, File.read!(cached_binary_path(version))) |> Base.encode16(case: :lower)
  end

  defp installed_binary_sha256(version) do
    :crypto.hash(:sha256, File.read!(installed_binary_path(version)))
    |> Base.encode16(case: :lower)
  end

  defp cached_binary_path(version) do
    Path.join(cache_dir(), "tailwind-freebsd-x64-#{version}")
  end

  defp cached_sha256_path(version) do
    Path.join(cache_dir(), "tailwind-freebsd-x64-#{version}.sha256")
  end

  defp installed_binary_path(_version) do
    Mix.Project.build_path()
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
