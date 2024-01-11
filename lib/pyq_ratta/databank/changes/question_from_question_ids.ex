defmodule PyqRatta.Databank.Changes.QuestionsFromQuestionIds do
  @moduledoc """
  Fetches questions from database to udpate the relationship from questions to quizzes
  """
  use Ash.Resource.Change

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion

  # def change(changeset, opts, context) do
  #   # caution: also preload the existing quetsions in the quiz and then add these ones.

  #   # IO.inspect(opts, label: "opts", limit: :infinity)
  #   # IO.inspect(context, label: "context", limit: :infinity)
  #   IO.inspect(changeset, label: "changeset", limit: :infinity)

  #   quiz_id = Ash.Changeset.get_data(changeset, :id)
  #   qids = Ash.Changeset.get_argument(changeset, :question_ids)

  #   questions =
  #     Enum.reduce(qids, [], fn qid, acc ->
  #       {:ok, question} = Question.read(qid)
  #       acc ++ [question]
  #     end)

  #   cs = Ash.Changeset.force_set_argument(changeset, :question_ids, questions)

  #   cs.arguments |> IO.inspect(label: "Ash.Changeset.set_argument cs.arguments", limit: :infinity)
  #   cs
  # end

  def change(changeset, opts, context) do
    # caution: also preload the existing quetsions in the quiz and then add these ones.

    # IO.inspect(opts, label: "opts", limit: :infinity)
    # IO.inspect(context, label: "context", limit: :infinity)
    IO.inspect(changeset, label: "changeset", limit: :infinity)

    quiz_id = Ash.Changeset.get_data(changeset, :id)
    qids = Ash.Changeset.get_argument(changeset, :question_ids)

    questions =
      Enum.reduce(qids, [], fn qid, acc ->
        {:ok, question} = Question.read(qid)
        acc ++ [question]
      end)

    cs = Ash.Changeset.force_set_argument(changeset, :question_ids, questions)

    cs.arguments |> IO.inspect(label: "Ash.Changeset.set_argument cs.arguments", limit: :infinity)
    cs
  end
end
