defmodule PyqRatta.QuizTest do
  use PyqRatta.DataCase, async: false

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion

  describe "Creating Questions: " do
    test "read/1 and create/1" do
      %{type: type, question_text: question_text} =
        question_params =
        Factory.questions_list_params()
        |> hd()

      assert {:ok, %{type: ^type, question_text: ^question_text, id: id}} =
               Question.create(question_params)

      assert {:ok, %{type: ^type, question_text: ^question_text, id: ^id}} = Question.read(id)
    end
  end

  describe "Creating Quiz: " do
    test "create_quiz_from_questions/1 with list of questions" do
      questions = Factory.questions_list_params()

      assert {:ok, %{id: quiz_id}} =
               Quiz.create_quiz_from_questions(questions)
    end

    test "update_quiz_with_question_ids/1 with list of questions" do
      require Factory
      require Ash.Query

      questions =
        Factory.insert_many_questions()

      # |> IO.inspect(label: "questions many inserted", limit: :infinity)

      qids = Enum.map(questions, & &1.id)

      {:ok, empty_quiz} = Quiz.create()

      # assert {:ok, %{id: quiz_id}} =
      #                Quiz.update_quiz_with_question_ids(empty_quiz, qids)
      #                |> IO.inspect(label: "update_quiz_with_question_ids", limit: :infinity)

      # Quiz.update_quiz_with_question_id(empty_quiz, qids |> hd())
      assert {:ok, %{id: quiz_id}} =
               Quiz.update_quiz_with_question_ids(empty_quiz, qids)
               |> IO.inspect(label: "update_quiz_with_question_ids", limit: :infinity)

      # {:ok, quiz} =
      #   Quiz.read(quiz_id)
      #   |> IO.inspect(label: "Quiz.read(quiz_id)", limit: :infinity)

      # Ash.Api.load(quiz, :questions)
      # |> IO.inspect(label: "update questions ", limit: :infinity)
    end
  end
end
