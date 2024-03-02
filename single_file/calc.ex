# File: calc.ex
defmodule Calc do
  # taken from https://elixirforum.com/t/sasa-jurics-beyond-task-async-blog/6107/6

  @spec run(Integer.t) :: Integer.t
  def run(id) when id > 0 do
    desc = "#{id} (#{inspect self()})"
    IO.puts (" sleeping: " <> desc)
    Process.sleep(id)
    IO.puts (" waking from slumber: " <> desc)
    id
  end
end

# File: accumulator.ex
defmodule Accumulator do
  def sum(addend, augend) do
    Process.sleep(500) # NOTE: This is responsible for some tasks
    addend + augend    # running beyond the timeout.
  end                  # The point is that only messages
end                    # up to the timeout message are actually processed
                       # See what happens when you comment "sleep" out

# File map_reduce.ex
defmodule MapReduce do
  use GenServer

  defp map_spawn(fun, reply_to),
    do: fn elem ->
          Kernel.spawn_monitor(
            fn ->
              reply =
                try do
                  {self(), {:ok, fun.(elem)}}
                rescue _ ->
                  {self(), :error}
                end
              GenServer.cast reply_to, reply
            end
          )
        end

  defp put_task({pid, ref}, tasks),
    do: Map.put tasks, pid, ref

  defp remove_task(tasks, pid),
    do: Map.delete tasks, pid

  defp purge_task({pid, ref}) do
    # No longer interested in the process
    # or the associated :DOWN messages
    Process.demonitor ref, [:flush]

    result =
      cond do
        Process.alive? pid ->
          Process.exit pid, :kill
        true ->
          false # no need
      end

    IO.puts "  purge task #{inspect pid}: #{inspect result}"

    result
  end

  defp cleanup_tasks(tasks) do
    tasks
    |> Map.to_list()
    |> Enum.each(&purge_task/1)
  end

  defp assess_progress({tasks, _, _, _, _} = state) do
    cond do
      tasks == %{} ->
        {:stop, :normal, state}
      true ->
        {:noreply, state}
    end
  end

  defp handle_result({tasks, acc, reduce, reply_to, timer_ref}, {pid, result}) do
    new_acc =
      case result do
        {:ok, value} ->
          reduce.(acc, value)
        :error ->
          acc # TODO account for errors in the reply to creator
      end

    assess_progress {(remove_task tasks, pid), new_acc, reduce, reply_to, timer_ref}
  end

  def handle_down({tasks, acc, reduce, reply_to, timer_ref}, pid, reason) do
    IO.puts "Task #{inspect pid} terminated with reason: #{inspect reason}"
    # TODO: should indicate in reply to creator that there are DOWN tasks
    assess_progress {(remove_task tasks, pid), acc, reduce, reply_to, timer_ref}
  end

  ## callbacks: message handlers
  def handle_cast({pid, _} = reply, {tasks, _, _, _, _} = state) when is_pid pid do
    # process result
    case Map.get tasks, pid, :none do
      :none ->
        {:noreply, state}
      ref ->
        Process.demonitor ref, [:flush] # purge :DOWN message
        handle_result state, reply
    end
  end
  def handle_cast(:init, {data, init, fun, reduce, reply_to, timeout}) do
    tasks =
      data
      |> Enum.map(map_spawn(fun, self()))
      |> Enum.reduce(%{}, &put_task/2)

    timer_ref = Process.send_after self(), :timeout, timeout
    {:noreply, {tasks, init, reduce, reply_to, timer_ref}}
  end

  def handle_info(:timeout, {tasks, acc, reduce, reply_to, _timer_ref}) do
    IO.puts "  !!! timeout !!!"
    {:stop, :normal, {tasks, acc, reduce, reply_to, :none}}
  end
  def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
    handle_down state, pid, reason
  end

  ## callbacks: lifecycle
  def init(arg) do
    GenServer.cast self(), :init   # return ASAP, i.e. delay initialization
    {:ok, arg}
  end

  def terminate(reason, {tasks, acc, _reduce, reply_to, timer_ref}) do
    reply =
      case {reason, timer_ref} do
        {:normal, :none} ->
          {:timeout, self(), acc}
        {:normal, _} ->
          Process.cancel_timer timer_ref
          {:ok, self(), acc}
        _ ->
          {:error, self(), reason}
      end

    cleanup_tasks tasks
    Kernel.send reply_to, reply

    IO.puts "  unprocessed messages - #{inspect (Process.info self(), :message_queue_len)}"
  end

  ## public interface
  def start(data, init, fun, reduce, timeout) do
    args = {data, init, fun, reduce, self(), timeout}
    # Note:  [spawn_opt: :monitor] is not allowed
    # http://erlang.org/doc/man/gen_server.html#start_link-4
    #
    case GenServer.start __MODULE__, args do
      {:ok, pid} ->
        ref = Process.monitor pid
        {pid, ref}
      other ->
        other
    end
  end

  def run_demo(diff \\ 0, timeout \\ 900) do
    data = Enum.map 1..10, fn _ -> Enum.random(1..1000) - diff end
    start data, 0, &Calc.run/1, &Accumulator.sum/2, timeout
  end

end
