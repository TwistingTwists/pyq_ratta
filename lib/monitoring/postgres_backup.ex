defmodule Monitoring.PostgresBackup do
  use GenServer

  require Logger

  @interval 1000 * 60 * 60 * 6

  # +--------------------+
  # |     Public API     |
  # +--------------------+

  def start_link(opts) do
    # We check to see if the process should even be started in the current
    # execution environment. If the process is not meant to run here, then
    # we return `:ignore` and the process is not started.

    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def backup_now() do
    # send backup request after 100 ms
    # Process.send_after(self(), :backup, 100)
    GenServer.cast(__MODULE__, :backup)
  end

  # +---------------------+
  # |      Callbacks      |
  # +---------------------+

  @impl true
  def init(_opts) do
    # Similarly to our cron job GenSever from Chapter 4, we lean on
    # the `handle_continue/2` callback to schedule our next
    # cron job execution.
    {:ok, nil, {:continue, :schedule_next_run}}
  end

  @impl true
  def handle_continue(:schedule_next_run, state) do
    Process.send_after(self(), :backup, @interval)

    {:noreply, state}
  end

  @impl true
  def handle_cast(:backup, state) do
    "received backup request" |> IO.inspect(label: "#{__ENV__.file}:#{__ENV__.line}")
    handle_info(:backup, state)
  end

  @impl true
  def handle_info(:backup, state) do
    # db-to-sqlite "postgresql://postgres:postgres@localhost/pyq_ratta_dev" $(date +"%Y-%m-%d_%H_%M_%S").db  --all -p

    MuonTrap.cmd("db-to-sqlite", [db_string(), backup_filename(), "--all", "-p"])
    |> IO.inspect(label: "#{__ENV__.file}:#{__ENV__.line}")

    Logger.info("postgres backed up to sqlite file")
    {:noreply, state, {:continue, :schedule_next_run}}
  end

  def db_string, do: "postgresql://postgres:postgres@localhost/pyq_ratta_dev"

  def backup_filename do
    (DateTime.utc_now()
     |> DateTime.truncate(:second)
     |> DateTime.to_string()
     |> String.replace(~r/[:\s]/, "_")
     |> String.replace(~r/[Z]/, "")
     |> String.replace(~r/-/, "_")) <>
      ".db"
  end
end
