defmodule PyqRatta.Factory do
  def questions_list_params do
    [
      %{
        question_text: "First question",
        question_image: "image/url/to/save/in/db",
        correct_answer_text: "A",
        type: "MCQ"
      }
    ]
  end
end
