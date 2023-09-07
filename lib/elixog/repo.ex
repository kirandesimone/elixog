defmodule Elixog.Repo do
  use Ecto.Repo,
    otp_app: :elixog,
    adapter: Ecto.Adapters.Postgres
end
