defmodule Pista.Repo do
  use Ecto.Repo,
    otp_app: :pista,
    adapter: Ecto.Adapters.Postgres
end
