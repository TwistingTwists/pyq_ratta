defmodule PyqRatta.Databank.Manual.UdpateQuiz do
  use Ash.Resource.ManualUpdate

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion

  def update(changeset, opts, context) do
    quiz_id = Ash.Changeset.get_data(changeset, :id)
    qids = Ash.Changeset.get_argument(changeset, :question_ids)

    Enum.map(
      qids,
      fn question_id ->
        QuizQuestion.relate(quiz_id, question_id)
        |> IO.inspect(label: "Creating relation")
      end
    )

    Quiz.read(quiz_id)
  end
end
