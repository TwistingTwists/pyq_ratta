defmodule PyqRatta.QuizTest do
  use PyqRatta.DataCase, async: false

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question

  describe "Creating Questions: " do
    test "create_question/1" do
      %{type: type, question_text: question_text} =
        question_params =
        Factory.questions_list_params()
        |> hd()

      assert {:ok, %{type: ^type, question_text: ^question_text}} =
               Question.create(question_params)
    end

    test "read/1" do
      %{type: type, question_text: question_text} =
        question_params =
        Factory.questions_list_params()
        |> hd()

      assert {:ok, %{type: ^type, question_text: ^question_text, id: id}} =
               Question.create(question_params)

      assert {:ok, %{type: ^type, question_text: ^question_text, id: ^id}} = Question.read(id)
    end
  end

  # describe "Creating Quiz: " do
  #   test "create_quiz/1 with list of questions" do
  #     questions =
  #       Factory.questions_list_params()
  #       |> IO.inspect(label: "quetions are ")

  #     assert {:ok, %{id: quiz_id, questions: questions}} =
  #              Quiz.create_new_quiz(questions: questions)
  #   end
  # end
end
