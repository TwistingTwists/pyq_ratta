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
  """
  use GenServer
  require Logger

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
    {:stop, { :shutdown ,"shutdown please"}, state}
    # {:stop, :shutdown, state}
    # {:stop, :normal, state}
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

Logger.configure(level: :info)

parent_pid = self()
|> IO.inspect(label: "#{__ENV__.file}:#{__ENV__.line}")

{:ok, pid} =
  GenServer.start_link(TestServer, [parent_pid: parent_pid])
  |> IO.inspect(label: "#{__ENV__.file}:#{__ENV__.line}")


receive do
  :done -> true
  any -> IO.puts("unexpected message: #{inspect(any)}")
  true
end
