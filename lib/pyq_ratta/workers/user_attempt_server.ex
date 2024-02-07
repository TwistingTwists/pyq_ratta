defmodule PyqRatta.Workers.UserAttemptServer do
  use GenServer, restart: :transient

  use TypedStruct

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion
  alias PyqRatta.Accounts
  alias PyqRatta.QuizPractice.Response
  alias PyqRatta.Telegram.Commands
  alias PyqRatta.Telegram.QuizChecker

  alias PyqRatta.Telegram.MessageFormatter, as: MF

  require MyInspect
  require Logger

  import Helpers.ColorIO

  typedstruct enforce: true, visibility: :opaque, module: Internal do
    @moduledoc "Internal state -- used to ensure that user_id and quiz_id are non_nil at all times."
    field :user_tg_id, Integer.t()
    field :quiz_id, String.t()
    # questions is used to send question to the user and then delete from this list.
    field :questions, List.t(), enforce: false
    field :quiz, List.t(), enforce: false
    field :user, Map.t(), enforce: false
    field :previous_question, Map.t(), enforce: false
    field :ref, any(), enforce: false
  end

  ###### Public API ######

  @doc "Start"
  def start_link(opts) do
    user_id = Keyword.get(opts, :user_tg_id, __MODULE__)
    quiz_id = Keyword.get(opts, :quiz_id, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: via(user_id))
  end

  def next(user_id, user_response) do
    GenServer.cast(via(user_id), {:send_next_question, user_response})
  end

  def current_state(user_id) do
    GenServer.call(via(user_id), :get_state)
  end

  ###### Callbacks ######

  @impl true
  def init(opts) do
    # Process.flag(:trap_exit, true)
    state = struct(__MODULE__.Internal, Map.new(opts))
    {:ok, state, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, %{user_tg_id: uid, quiz_id: qid} = state) do
    {:ok, quiz} = Quiz.read_by_id(qid)
    {:ok, user} = Accounts.User.by_tgid(uid)
    state = %{state | questions: quiz.questions, quiz: quiz, user: user}

    {question, new_state} = do_send_next_question(state)

    Commands.send_to_tg(state.user_tg_id, question)

    {:noreply, new_state}
  end

  def handle_cast({:send_next_question, user_response}, state),
    do: handle_info({:send_next_question, user_response}, state)

  def handle_info({:send_next_question, user_response}, state) do
    # it will check and reply in async.
    # QuizChecker.check(state.previous_question, user_response, state.user_tg_id)

    task =
      Task.Supervisor.async_nolink(PyqRatta.Telegram.TaskSupervisor, fn ->
        QuizChecker.handle_cast(
          {:check_and_reply, state.previous_question, state.quiz, user_response,
           state.user_tg_id},
          %{}
        )
      end)

    state = %{state | ref: task.ref}
    {:noreply, state}
  end

  def handle_call(:get_state, from, state) do
    {:reply, state, state}
  end

  # The task completed successfully
  def handle_info({ref, answer}, %{ref: ref} = state) do
    # We don't care about the DOWN message now, so let's demonitor and flush it
    Process.demonitor(ref, [:flush])
    answer |> red("received from the task that finished ")
    # if task finished successfully, then we send the next question or shutdown the genserver

    state = %{state | ref: nil}

    case do_send_next_question(state) do
      {:finished, new_state} ->
        new_state.previous_question |> purple("QUIZ FINISHED SUCCESSFULLY")
        # shutdown genserver.
        # send results to the original caller
        # {:finished,new_state}

        {msg, opts} = MF.quiz_finished()
        ExGram.send_message(state.user_tg_id, msg, opts)

        Process.sleep(500)
        |> green("Shutting down the genserver")

        # {:stop, {:shutdown, :quiz_finished}, new_state}
        {:stop, :normal, new_state}

      {question, new_state} ->
        # schedule_next_question()
        # send the question to whosoever asked.
        yellow("Scheduling next question genserver")
        Commands.send_to_tg(state.user_tg_id, question)
        # return new_state
        {:noreply, new_state}
    end
  end

  # The task failed
  def handle_info({:DOWN, ref, :process, _pid, _reason}, %{ref: ref} = state) do
    # Log and possibly restart the task...
    Logger.error(
      "Task Failed: for quesiton: #{state.previous_question.id}, Correct_Ans: #{state.previous_question.correct_answer_text}"
    )

    {:noreply, %{state | ref: nil}}
  end

  def terminate({:shutdown, :quiz_finished}, state) do
    {msg, opts} = MF.quiz_finished()
    ExGram.send_message(state.user_tg_id, msg, opts)
    :ok
  end

  def terminate(_any, state) do
    {msg, opts} = MF.quiz_crashed()
    ExGram.send_message(state.user_tg_id, msg, opts)
    :ok
  end

  ###### private functions  ######

  def do_send_next_question(%{questions: []} = state) do
    new_state = %{state | previous_question: %{}}

    {:finished, state}
  end

  def do_send_next_question(%{questions: [question]} = state) do
    new_state = %{state | questions: [], previous_question: question}
    {question, new_state}
  end

  def do_send_next_question(%{questions: [question | rest]} = state) do
    new_state = %{state | questions: rest, previous_question: question}
    {question, new_state}
  end

  def via(user_id) do
    Commands.via(user_id)
  end
end
