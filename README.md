# phx_tailwind_freebsd

Workaround to install Tailwind binary on FreeBSD.

Does this look familiar?

![Screenshot_20240401_224433](https://github.com/hiway/phx_tailwind_freebsd/assets/23116/350de53f-843e-4510-9284-18f529219bbf)


References:
- https://github.com/phoenixframework/tailwind/issues/49
- https://github.com/tailwindlabs/tailwindcss/discussions/7826#discussioncomment-8788435


## Installation

Add `phx_tailwind_freebsd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_tailwind_freebsd, "~> 0.2.1", runtime: Mix.env() == :dev}
  ]
end
```


## Usage

Run `mix tailwind.install_freebsd` in the project directory.
