defmodule PyqRatta.Telegram.QuizChecker do
  use GenServer
  alias PyqRatta.Telegram.Quizbot
  alias PyqRatta.Telegram.Commands
  alias PyqRatta.Accounts
  alias PyqRatta.QuizPractice.Response, as: UserResponse
  alias PyqRatta.Telegram.MessageFormatter, as: MF

  import Helpers.ColorIO
  require MyInspect
  # get a question, and match the given answer with correct answer.
  # Reply to the use accordingly.

  # Save user response in db.

  ###### Public API ######

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: via())
  end

  def check(question, quiz, user_response, user_tg_id) do
    GenServer.cast(via(), {:check_and_reply, question, quiz, user_response, user_tg_id})
  end

  ###### Callbacks ######

  @impl true
  def init(opts) do
    {:ok, %{}}
  end

  def handle_cast({:check_and_reply, question, quiz, user_response, user_tg_id}, state) do
    [question, user_response, user_tg_id] |> MyInspect.print()

    user_response = String.downcase(user_response)

    is_correct = is_correct?(question, user_response)

    {msg, opts} =
      if is_correct do
        MF.correct_ans_reply(question.correct_answer_text)
      else
        MF.wrong_ans_reply(question.correct_answer_text)
      end

    # todo save user response in database.

    with {:ok, user} <- Accounts.User.by_tgid(user_tg_id) do
      UserResponse.save(user_tg_id, quiz.id, question.id, %{attempted_answer: user_response})
      |> purple("userresonse.save")
    end

    opts = opts ++ [bot: Quizbot.bot()]
    ExGram.send_message(user_tg_id, msg, opts)

    {:noreply, state}
  end

  defp is_correct?(question, user_response) do
    correct = question.correct_answer_text |> String.downcase()
    correct == String.downcase(user_response)
  end

  def via(user_id \\ "QuizChecker") do
    Commands.via(user_id)
  end
end
