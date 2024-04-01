# phx_tailwind_freebsd

Workaround to install Tailwind binary on FreeBSD.

Does this look familiar?



References:
- https://github.com/phoenixframework/tailwind/issues/49
- https://github.com/tailwindlabs/tailwindcss/discussions/7826#discussioncomment-8788435


## Installation

Add `phx_tailwind_freebsd` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:phx_tailwind_freebsd, "~> 0.1.0"}
  ]
end
```


## Usage

Run `mix tailwind.install_freebsd` in the project directory.
