defmodule PyqRatta.Workers.UserAttemptServer do
  use GenServer

  use TypedStruct

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion
  alias PyqRatta.Accounts
  alias PyqRatta.QuizPractice.Response
  alias PyqRatta.Telegram.Commands

  typedstruct enforce: true, visibility: :opaque, module: Internal do
    @moduledoc "Internal state -- used to ensure that user_id and quiz_id are non_nil at all times."
    field :user_tg_id, String.t()
    field :quiz_id, String.t()
    # questions is used to send question to the user and then delete from this list.
    field :questions, List.t(), enforce: false
    field :quiz, List.t(), enforce: false
    field :user, Map.t(), enforce: false
  end

  ###### Public API ######

  @doc "Start"
  def start_link(opts) do
     user_id  = Keyword.get(opts, :user_tg_id, __MODULE__)
     quiz_id = Keyword.get(opts, :quiz_id, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: via( user_id ))
  end

  def next(user_id) do
    GenServer.cast(via(user_id), :send_next_question )
  end

  def current_state(user_id) do
    GenServer.call(via(user_id), :get_state )

  end

  ###### Callbacks ######

  @impl true
  def init(opts) do
    state = struct(__MODULE__.Internal, Map.new(opts))
    {:ok, state, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, %{user_tg_id: uid, quiz_id: qid} = state) do
    {:ok, quiz} = Quiz.read_by_id(qid)
    {:ok, user} = Accounts.User.by_tgid(uid)

    {:noreply, %{state | questions: quiz.questions, quiz: quiz, user: user}}
  end

  def handle_cast(:send_next_question, state), do: handle_info(:send_next_question, state)


  def handle_info(:send_next_question, state)do
  case do_send_next_question(state) do
      {:finished, new_state} ->
      # shutdown genserver.
      # send results to the original caller
      # {:finished,new_state}
      {:stop, {:shutdown, :quiz_finished}, state}


      {question,  new_state} ->
      # schedule_next_question()
      # send the question to whosoever asked.
      Commands.send_to_tg(state.user_tg_id, question)
      # return new_state
    {:noreply, new_state}

    end

  end

  def handle_call(:get_state, from, state) do
    {:reply, state, state}
  end

  ###### private functions  ######

  def do_send_next_question(%{questions: []} = state) do
      {:finished, state}
    end

    def do_send_next_question(%{questions: [question]} = state) do
      new_state = %{state | questions: []}
      {question, new_state}
    end

    def do_send_next_question(%{questions: [question | rest]} = state) do
      new_state = %{state | questions: rest}
      {question, new_state}
    end


  def via(user_id) do
    Commands.via(user_id)
  end
end
