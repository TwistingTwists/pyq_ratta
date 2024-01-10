defmodule PyqRatta.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PyqRattaWeb.Telemetry,
      PyqRatta.Repo,
      {DNSCluster, query: Application.get_env(:pyq_ratta, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PyqRatta.PubSub},
      {Registry, keys: :unique, name: PyqRatta.Workers.QuizServerRegistry},
      {Registry, keys: :unique, name: PyqRatta.Workers.UserAttemptServerRegistry},
      {DynamicSupervisor, strategy: :one_for_one, name: PyqRatta.User.DynamicSupervisor},
      {PartitionSupervisor, child_spec: Task.Supervisor, name: PyqRatta.Telegram.TaskSupervisors},
      # PyqRatta.Workers.QuizServer,
      # PyqRatta.Workers.UserAttemptServer,
      # Start the Finch HTTP client for sending emails
      {Finch, name: PyqRatta.Finch},
      # Start to serve requests, typically the last entry
      PyqRattaWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: PyqRatta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PyqRattaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
