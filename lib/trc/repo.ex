defmodule TRC.Repo do
  use Ecto.Repo,
    otp_app: :trc,
    adapter: Ecto.Adapters.Postgres
end
