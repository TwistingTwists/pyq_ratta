defmodule PyqRatta.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children =
      [
        PyqRattaWeb.Telemetry,
        PyqRatta.Repo,
        {DNSCluster, query: Application.get_env(:pyq_ratta, :dns_cluster_query) || :ignore},
        {Phoenix.PubSub, name: PyqRatta.PubSub},
        {Cachex, name: :users},
        PyqRatta.Telegram.Commands,
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
        add_bots()

    opts = [strategy: :one_for_one, name: PyqRatta.Supervisor]
    Supervisor.start_link(children, opts)
  end

  if Mix.env() == :test do
    def add_bots do
      []
    end
  else
    def add_bots() do
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
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PyqRattaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
