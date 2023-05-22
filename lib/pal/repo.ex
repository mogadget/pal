defmodule Pal.Repo do
  use Ecto.Repo,
    otp_app: :pal,
    adapter: Ecto.Adapters.Postgres
end
