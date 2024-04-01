defmodule PhxTailwindFreebsd.MixProject do
  use Mix.Project

  def project do
    [
      app: :phx_tailwind_freebsd,
      version: "0.1.2",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [
        main: "PhxTailwindFreebsd",
        # logo: "path/to/logo.png",
        extras: ["README.md"]
      ],
      source_url: "https://github.com/hiway/phx_tailwind_freebsd/"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Workaround to install Tailwind binary on FreeBSD."
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/hiway/phx_tailwind_freebsd/"}
    ]
  end
end
