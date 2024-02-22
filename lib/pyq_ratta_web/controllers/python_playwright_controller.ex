defmodule PyqRattaWeb.PythonPlaywrightController do
  use PyqRattaWeb, :controller
  import Helpers.ColorIO
  require Logger
  alias PyqRatta.Databank
  alias PyqRatta.Telegram.Commands

  def from_python(conn, %{"quiz" => quiz_data}) do
    quiz_data |> purple("received:")

    with {:ok, questions_params_array} <- parse(quiz_data),
         {:ok, quiz} <- Databank.Quiz.create_quiz_from_questions(questions_params_array) do
      _task =
        Task.Supervisor.async_nolink(PyqRatta.Telegram.TaskSupervisor, fn ->
          PyqRatta.Notifications.insert({:notify_created, quiz})
          Commands.send_quiz_ready(quiz)
          green("sent #{quiz.id}to telegram")
        end)

      conn
      |> put_status(200)
      |> json(%{message: "received"})
    else
      _ ->
        PyqRatta.Notifications.insert({:notify_not_created, "not created"})

        conn
        |> put_status(404)
        |> json(%{"message" => "Quiz could not be created"})
    end
  end

  def parse([]) do
    {:error, :empty_quiz}
  end

  def parse(quiz_list) when is_list(quiz_list) do
    quesetion_summary = do_parse(quiz_list)
    # filter each value from above.
    {:ok, quesetion_summary}
  end

  def do_parse([question]) do
    [do_parse(question)]
  end

  def do_parse([question | rest]) do
    # [do_parse(question) | do_parse(rest)]
    List.flatten([do_parse(question)] ++ [do_parse(rest)])
  end

  def do_parse(
        %{
          "short_description" => short_description,
          "question_image" => question_image,
          "inner_text" => inner_text,
          "correct_answer" => correct_answer
        } = incoming
      ) do
    # val =
    # inner_text
    # |> String.replace("–", "")
    # |> String.replace("(", "")
    # # |> PyqRatta.QuizParser.parse_question()
    # |> green("parsed question")

    correct_answer =
      case correct_answer do
        "0" ->
          "A"

        "1" ->
          "B"

        "2" ->
          "C"

        "3" ->
          "D"

        what ->
          Logger.warning("correct_answer: #{what} - received strange response from API")
          "ZZ"
      end

    Map.merge(incoming, %{"question_text" => inner_text, "correct_answer_text" => correct_answer})
  end
end
