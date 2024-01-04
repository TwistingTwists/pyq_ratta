defmodule PyqRatta.Repo do
  use Ecto.Repo,
    otp_app: :pyq_ratta,
    adapter: Ecto.Adapters.Postgres
end
