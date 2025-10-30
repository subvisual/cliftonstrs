defmodule Talents.Repo do
  use Ecto.Repo,
    otp_app: :talents,
    adapter: Ecto.Adapters.Postgres
end
