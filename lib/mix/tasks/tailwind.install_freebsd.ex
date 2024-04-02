defmodule Mix.Tasks.Tailwind.InstallFreebsd do
  @moduledoc """
  Workaround to install Tailwind binary on FreeBSD.
  """
  use Mix.Task

  @doc """
  Install Tailwind binary for FreeBSD.
  """
  def run(_) do
    PhxTailwindFreebsd.install_tailwind_on_freebsd()
  end
end
