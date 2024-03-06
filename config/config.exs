# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :pyq_ratta,
  tg_bots: [
    %{
      module_name: PyqRatta.Telegram.Quizbot,
      token: System.get_env("QUIZ_BOT_TOKEN"),
      name: System.get_env("QUIZ_BOT_NAME")
    }
  ]

config :pyq_ratta, MonitoringTools.MemoryWatcher, enabled: true
config :pyq_ratta, MonitoringTools.ReductionWatcher, enabled: true

config(:pyq_ratta,
  ash_apis: [PyqRatta.Databank, PyqRatta.Accounts, PyqRatta.QuizPractice],
  ecto_repos: [PyqRatta.Repo],
  generators: [timestamp_type: :utc_datetime]
)

config :ash,
  use_all_identities_in_manage_relationship?: false

config :flashy,
  disconnected_module: PyqRattaWeb.Components.Notifications.Disconnected

# Configures the endpoint
config :pyq_ratta, PyqRattaWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PyqRattaWeb.ErrorHTML, json: PyqRattaWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PyqRatta.PubSub,
  live_view: [signing_salt: "+fkjlNia"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :pyq_ratta, PyqRatta.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
metadata =
  if Mix.env() == :dev do
    [
      :request_id,
      # to connect traces and logs
      :span_id,
      :trace_id
    ]
  else
    [
      :file,
      :line,
      :function,
      :module,
      :application,
      :httpRequest,
      :query,
      :request_id,
      # to connect traces and logs
      :span_id,
      :trace_id
    ]
  end

config :logger,
  backends: [
    :console,
    {LoggerFileBackend, :info},
    {LoggerFileBackend, :debug},
    {LoggerFileBackend, :error}
  ],
  format: {Medea.Formatter, :format}

config :logger, :info,
  path: "log/info.log",
  level: :info,
  metadata: metadata

config :logger, :error,
  path: "log/error.log",
  level: :error,
  metadata: metadata

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  metadata: metadata

config :opentelemetry, :resource, service: %{name: "pyq_ratta_#{Mix.env()}"}
config :opentelemetry, :propagators, :otel_propagator_http_w3c

# format: "$time $metadata[$level] $message\n",
# metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
