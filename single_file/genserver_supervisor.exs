defmodule TestServer do
  @moduledoc """
  
  #########################
  TERMINATE
  #########################

  * terminate/2 is called when
    - any case of block `Communication to parent` happens

  #########################
  Communication to parent
  #########################

  * {:stop, :normal, state} -> no msg being sent to caller process
  * {:stop, :shutdown, state} -> {:EXIT, :shutdown} to caller process
  * {:stop, { :shutdown, reason}, state} -> {:EXIT, { :shutdown, reason}} to caller process

  #########################
  Communication from parent
  #########################

  * 



  #########################
  Restart strategies in GenServer and Supervisors
  #########################
  Copied from docs. 
  
  :permanent - the child process is always restarted.

  :temporary - the child process is never restarted, regardless of the supervision strategy: any termination (even abnormal) is considered successful.

  :transient - the child process is restarted only if it terminates abnormally, i.e., with an exit reason other than :normal, :shutdown, or {:shutdown, term}.

  """


  # use GenServer, restart: :temporary
  use GenServer, restart: :transient
  require Logger

  
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end


  @impl true
  def init(opts) do
    # Process.flag(:trap_exit, true)
    schedule_ping()
    {:ok, %{count: 0, parent_pid: opts[:parent_pid]}}
  end

  @impl true
  def handle_info(:ping, %{count: count}=state) when count < 3 do
    IO.puts("#{state.count} - pong")
    schedule_ping()
    {:noreply, %{state | count: count+1}}
  end

  def handle_info(:ping, state) do
    IO.puts("done")
    random_exit_message(state)
  end

def random_exit_message(state) do 
  [
    # {:stop, { :shutdown ,"shutdown please"}, state},
    # {:stop, :normal, state}
    {:stop, {:abnormal_message ,"abnormal exit"}, state}
  ]
  |> Enum.random()
  |> IO.inspect()
end

  def handle_info(event, state) do
    Logger.info("Unhandled : #{event} :#{__ENV__.file}:#{__ENV__.line} ")
    {:stop, :normal, state}
  end

  def schedule_ping() do
    Process.send_after(self(), :ping, 800)
  end

  @impl true
  def terminate(reason, state) do 
    IO.puts("Terminating with reason: #{inspect(reason)}")
    # send(state.parent_pid, :done)
  end
end


defmodule TestSupervisor do
  use Supervisor
  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, {}, name: __MODULE__)
  end

  def init(_args) do
    parent_pid = self()
    children = [
      {TestServer, parent_pid: parent_pid}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end

Logger.configure(level: :info)

supervisor_pid = TestSupervisor.start_link(:ok)
  |> IO.inspect(label: "#{__ENV__.file}:#{__ENV__.line}")

receive do
  :done -> true
  any -> IO.puts("unexpected message: #{inspect(any)}")
  true
end
