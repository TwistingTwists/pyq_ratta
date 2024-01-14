defmodule PyqRatta.Workers.UserAttemptServer do
  use GenServer

  use TypedStruct

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion
  alias PyqRatta.Accounts
  alias PyqRatta.QuizPractice.Response

  typedstruct enforce: true, visibility: :opaque, module: Internal do
    @moduledoc "Internal state -- used to ensure that user_id and quiz_id are non_nil at all times."
    field :user_tg_id, String.t()
    field :quiz_id, String.t()
    # questions is used to send question to the user and then delete from this list.
    field :questions, List.t(), enforce: false
    field :quiz, List.t(), enforce: false
  end

  ###### Public API ######

  @doc "Start"
  def start_link(opts) do
    {user_id, gen_opts} = Keyword.get(opts, :user_tg_id, __MODULE__)
    {quiz_id, gen_opts} = Keyword.get(gen_opts, :quiz_id, __MODULE__)

    GenServer.start_link(__MODULE__, opts, name: via({user_id, quiz_id}))
  end

  def start_quiz(platform_id) do
    GenServer.call(__MODULE__, {:get_client, platform_id})
  end

  def send_next_question(%{questions: []} = state) do
    {:finished, state}
  end

  def send_next_question(%{questions: [question]} = state) do
    new_state = %{state | questions: []}
    {question, new_state}
  end

  def send_next_question(%{questions: [question | rest]} = state) do
    new_state = %{state | questions: rest}
    {question, new_state}
  end

  ###### Callbacks ######

  @impl true
  def init(opts) do
    state = struct(__MODULE__.Internal, Map.new(opts))
    {:ok, %{internal: state}, {:continue, :start}}
  end

  @impl true
  def handle_continue(:start, %{user_tg_id: uid, quiz_id: qid} = state) do
    {:ok, quiz} = Quiz.read_by_id(qid)
    # {:ok, user} = Accounts.User.get_by(uid)

    {:noreply, %{state | questions: quiz.questions, quiz: quiz}}
  end

  def via({user_id, quiz_id}) do
    {:via, Registry, {PyqRatta.UserAttemptRegistry, {user_id, quiz_id}}}
  end
end
