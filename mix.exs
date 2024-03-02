defmodule PyqRatta.MixProject do
  use Mix.Project

  @version "1.0.0"

  def project do
    [
      app: :pyq_ratta,
      version: @version,
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
      extra_applications: [:logger, :runtime_tools, :observer, :wx]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # caching

      {:cachex, "~> 3.6"},

      # all ash

      #  UI components
      {:ash, "~> 2.18"},
      {:ash_admin, "~> 0.10"},
      {:ash_authentication, "~> 3.11"},
      {:ash_authentication_phoenix, "~> 1.8"},
      {:ash_oban, "~> 0.1.13"},
      {:ash_phoenix, "~> 1.2"},
      {:ash_postgres, "~> 1.4"},
      {:ash_state_machine, "~> 0.2.2"},

      # {:flashy, "~> 0.2.5"},
      {:flashy, git: "https://github.com/sezaru/flashy", branch: "master"},
      {:live_select, "~> 1.0"},
      {:petal_components, "~> 1.7"},

      # phoenix core

      # {:plug_cowboy, "~> 2.5"},
      {:bandit, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:ecto_sql, "~> 3.10"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:finch, "~> 0.13"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.20"},
      {:jason, "~> 1.2"},
      {:phoenix, "~> 1.7.10"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_dashboard, "~> 0.8.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.20.1"},
      {:postgrex, ">= 0.0.0"},
      {:swoosh, "~> 1.3"},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},

      # telegram

      {:ex_gram, "~> 0.50.0"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      # dev tools
      # {:ecto_erd, "~> 0.5", only: :dev}

      # Testing

      {:ex_machina, "~> 2.7"},
      {:faker, "~> 0.17"},
      {:mock, "~> 0.3.8", only: :test},
      {:stream_data, "~> 0.6"},

      # code quality
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},

      # gitops - automatic changelog
      {:git_ops, "~> 2.6.0", only: [:dev]},

      # system cmd
      {:muontrap, "~> 1.0"},

      # parser combinators
      {:nimble_parsec, "~> 1.4.0"},
      {:pegasus, "~> 0.2.4"},

      # Observability and logging
      {:logger_file_backend, "~> 0.0.13"},
      # {:medea, "~> 0.1"},
      {:medea, path: "./shared/medea"},

      # opentelemetry
      # {:opentelemetry_telemetry, "~> 1.1"},
      {:opentelemetry, "~> 1.3"},
      {:opentelemetry_api, "~> 1.2"},
      {:opentelemetry_bandit, "~> 0.1"},
      {:opentelemetry_ecto, "~> 1.2"},
      {:opentelemetry_exporter, "~> 1.0"},
      {:opentelemetry_liveview, "~> 1.0.0-rc.4"},
      {:opentelemetry_logger_metadata, "~> 0.1.0"},
      {:opentelemetry_phoenix, "~> 1.2"},
      {:opentelemetry_telemetry, "~> 1.0"},
      # telemetry
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"}
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
