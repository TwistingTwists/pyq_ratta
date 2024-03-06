defmodule MonitoringTools.ReductionWatcher do
  use GenServer

  require Logger

  @interval 10_000
  @top_n 5

  # +--------------------+
  # |     Public API     |
  # +--------------------+

  def start_link(opts) do
    # We check to see if the process should even be started in the current
    # execution environment. If the process is not meant to run here, then
    # we return `:ignore`, and the process is not started.
    if start_server?() do
      GenServer.start_link(__MODULE__, opts, name: __MODULE__)
    else
      :ignore
    end
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
    Process.send_after(self(), :log_top_n, @interval)

    {:noreply, state}
  end

  @impl true
  def handle_info(:log_top_n, state) do
    # We lean on the `Process` module to capture process
    # information like reduction count, and we get the top five
    # reduction-heavy processes.
    top_reduction_processes =
      Process.list()
      |> Enum.map(fn pid ->
        measurement =
          pid
          |> Process.info(:reductions)
          |> elem(1)

        {pid, measurement}
      end)
      |> Enum.sort_by(
        fn {_pid, total_heap_size} ->
          total_heap_size
        end,
        :desc
      )
      |> Enum.take(@top_n)

    Logger.info("Top reduction processes: #{inspect(top_reduction_processes)}")

    {:noreply, state, {:continue, :schedule_next_run}}
  end

  # +---------------------------+
  # |      Private Helpers      |
  # +---------------------------+

  # This function checks the application configuration to see if there
  # is anything set there to control the start-up of this process.
  # If nothing is present in the application configuration, the process
  # is started.
  defp start_server? do
    :pyq_ratta
    |> Application.get_env(__MODULE__, [])
    |> Keyword.get(:enabled, true)
  end
end
