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
end
