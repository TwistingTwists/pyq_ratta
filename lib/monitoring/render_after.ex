defmodule MonitoringTools.RenderAfter do
  @moduledoc """
  to be run in livebook to enable rendering cells which are updated on click of a button
  """
  use GenServer

  require Logger

  #   @interval 1000 * 60 * 30
  @interval 1000

  # +--------------------+
  # |     Public API     |
  # +--------------------+

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # +---------------------+
  # |      Callbacks      |
  # +---------------------+

  @impl true
  def init(_opts) do
    # Similarly to our cron job GenSever from Chapter 4, we lean on
    # the `handle_continue/2` callback to schedule our next
    # cron job execution.
    state = %{database_path: nil, conn: nil}

    {:ok, state, {:continue, :schedule_next_run}}
  end

  def get_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  @impl true
  def handle_continue(:schedule_next_run, state) do
    Process.send_after(self(), :log_top_n, @interval)
    {:noreply, update_state(state)}
  end

  def handle_call(:get_state, from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:log_top_n, state) do
    {:noreply, update_state(state), {:continue, :schedule_next_run}}
  end

  def update_state(state) do
    {:ok, database_path} = LatestFile.latest_db_file("/data/")
    {:ok, conn} = Kino.start_child({Exqlite, database: database_path})
    # Logger.info("Top memory processes: #{inspect(top_memory_processes)}")
    %{state | database_path: database_path, conn: conn}
  end
end
