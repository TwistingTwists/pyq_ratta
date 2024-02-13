defmodule PyqRattaWeb.PythonPlaywrightController do
  use PyqRattaWeb, :controller

  def from_python(conn, %{"quiz" => quiz_data}) do
    with {:ok, questions_params_array} <- parse(quiz_data),
         {:ok, quiz} <- Quiz.create_quiz_from_questions(questions_params_array) do
      conn
      |> put_status(200)
      |> json(%{message: "received"})
    else
      conn
      |> put_status(404)
      |> json(%{"message" => "Quiz could not be created"})
    end
  end

  def parse([question]) do
    [do_parse(question)]
  end

  def parse([question | rest]) do
  end

  def do_parse(%{
        "short_description" => short_description,
        "question_image" => question_image,
        "inner_text" => inner_text
      }) do
  end
end
