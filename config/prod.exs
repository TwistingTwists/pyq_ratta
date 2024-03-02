import Config

# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix assets.deploy` task,
# which you should run after static files are built and
# before starting your production server.
config :pyq_ratta, PyqRattaWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Configures Swoosh API Client
config :swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: PyqRatta.Finch

# Disable Swoosh Local Memory Storage
config :swoosh, local: false

# Do not print debug messages in production
config :logger, level: :info

otel_collector_host = System.get_env("OTEL_COLLECTOR_HOST")
otel_collector_port = System.get_env("OTEL_COLLECTOR_PORT")

if otel_collector_host && otel_collector_port do
  # otel_collector_host = String.to_charlist(otel_collector_host)
  # {otel_collector_port, ""} = Integer.parse(otel_collector_port)

  config :opentelemetry, :processors,
    otel_batch_processor: %{
      exporter:
        {:opentelemetry_exporter,
         %{endpoints: [{:http, otel_collector_host, otel_collector_port, []}]}}
    }
end

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.
