defmodule PyqRatta.Factory do
  alias __MODULE__

  def questions_list_params do
    [
      %{
        question_text: "First question",
        question_image: "image/url/to/save/in/db",
        correct_answer_text: "A",
        type: "MCQ"
      },
      %{
        question_text: "second  question",
        question_image: "image/url/to/save/in/db",
        correct_answer_text: "B",
        type: "MCQ"
      }
    ]
  end

  def quiz_params do
    %{
      year: 2020,
      tags: ["pyq", "environment"]
    }
  end

  defmacro insert_many_questions do
    quote do
      alias PyqRatta.Databank.Quiz
      alias PyqRatta.Databank.Question
      questions_params_list = Factory.questions_list_params()

      questions_in_db =
        Enum.reduce(questions_params_list, [], fn question_params, acc ->
          {:ok, question} = Question.create(question_params)
          acc ++ [question]
        end)
    end
  end

  ########## Accounts ##########
  def telegram_ids do
    [1, 2, 3, 3, 4, 5, 6]
  end
end
