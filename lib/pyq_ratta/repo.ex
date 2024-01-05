defmodule PyqRatta.Repo do
  # use Ecto.Repo,
  use AshPostgres.Repo,
    otp_app: :pyq_ratta
    # adapter: Ecto.Adapters.Postgres
  

  def installed_extensions do
    [
      "ash-functions",
      "citext",
      "uuid-ossp"
    ]
  end
end
