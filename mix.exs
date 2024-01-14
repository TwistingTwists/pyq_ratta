defmodule PyqRatta.MixProject do
  use Mix.Project

  def project do
    [
      app: :pyq_ratta,
      version: "0.1.2",
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PyqRatta.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # all ash
      {:ash_admin, "~> 0.10"},
      {:ash_authentication_phoenix, "~> 1.8"},
      {:ash_authentication, "~> 3.11"},
      {:ash_phoenix, "~> 1.2"},
      {:ash_postgres, "~> 1.4"},
      {:ash, "~> 2.18"},
      #  UI components
      {:live_select, "~> 1.0"},
      # {:flashy, "~> 0.2.5"},
      {:flashy, git: "https://github.com/sezaru/flashy", branch: "master"},
      {:petal_components, "~> 1.7"},
      # phoenix core
      {:phoenix, "~> 1.7.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:finch, "~> 0.13"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:plug_cowboy, "~> 2.5"},
      # telegram
      {:ex_gram, "~> 0.50.0"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      # dev tools
      # {:ecto_erd, "~> 0.5", only: :dev}

      # Testing
      # {:ex_machina, "~> 2.7"},
      {:faker, "~> 0.17"},
      {:mock, "~> 0.3.8", only: :test}
      # {:stream_data, "~> 0.6", only: :test}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ash_postgres.setup", "assets.setup", "assets.build"],
      # "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      # "ashdb.setup": [
      #   "ash_postgres.create",
      #   "ash_postgres.migrate",
      #   "run priv/repo/seeds.exs"
      # ],
      "ashdb.reset": ["ash_postgres.drop", "ashdb.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind default", "esbuild default"],
      "assets.deploy": ["tailwind default --minify", "esbuild default --minify", "phx.digest"]
    ]
  end
end
