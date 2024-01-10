defmodule PyqRatta.Factory do
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
end
