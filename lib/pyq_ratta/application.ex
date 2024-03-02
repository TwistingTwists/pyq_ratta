defmodule PyqRatta.Application do
  @moduledoc false

  use Application
  require Logger

  @impl true
  def start(_type, env) do
    setup_metrics(env)

    children =
      [
        PyqRattaWeb.Telemetry,
        PyqRatta.Telegram.BufferedSender,
        PyqRatta.Repo,
        {Cachex, name: :users_cache},
        {DNSCluster, query: Application.get_env(:pyq_ratta, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: PyqRatta.PubSub},
        # PyqRatta.PyWorker,
        PyqRatta.Telegram.Commands,
        PyqRatta.Notifications,
        # {PartitionSupervisor,
        # child_spec: Task.Supervisor, name: PyqRatta.Telegram.TaskSupervisor},
        {Task.Supervisor, name: PyqRatta.Telegram.TaskSupervisor},
        # Start the Finch HTTP client for sending emails
        {Finch, name: PyqRatta.Finch},
        # Start to serve requests, typically the last entry
        PyqRattaWeb.Endpoint,
        # Start the unique task dependencies
        Livebook.Utils.UniqueTask
      ] ++
        add_bots(env)

    opts = [strategy: :one_for_one, name: PyqRatta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp users_cache(), do: :users_cache

  # if Mix.env() == :test do
  def add_bots(:env) do
    []
  end

  # else
  def add_bots(_) do
    bots_list =
      case Application.fetch_env(:pyq_ratta, :tg_bots) do
        :error ->
          []

        {:ok, values} when is_list(values) ->
          Enum.map(values, fn val ->
            {val.module_name, [method: :polling, token: val.token]}
          end)

        _ ->
          raise """
          Need to setup at least one bot in config.exs. Example:

          ```elixir

          config :pyq_ratta,
            tg_bots: [
              %{
                module_name: PyqRatta.Telegram.Quizbot,
                token: System.get_env("QUIZ_BOT_TOKEN"),
                name: "@rem123_me_bot"
              }
            ]
          ```
          """
      end

    [ExGram | bots_list]
  end

  # end

  def setup_metrics(:test), do: nil

  def setup_metrics(_) do
    # Logger.add_translator({Medea.Translator, :translate})
    OpentelemetryPhoenix.setup()
    OpentelemetryLiveView.setup()
    OpentelemetryEcto.setup([:pyq_ratta, :repo])
    OpentelemetryLoggerMetadata.setup()
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PyqRattaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
