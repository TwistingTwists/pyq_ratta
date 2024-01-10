defmodule PyqRatta.Databank.QuizQuestion do
  @moduledoc """
  The join resource between Quiz and Question
  """
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question

  postgres do
    table "quiz_questions"
    repo PyqRatta.Repo

    references do
      reference :quiz, on_delete: :delete
      reference :question, on_delete: :delete
    end
  end

  actions do
    defaults [:create, :read, :update, :destroy]
  end

  relationships do
    belongs_to :quiz, Quiz, primary_key?: true, allow_nil?: false
    belongs_to :question, Question, primary_key?: true, allow_nil?: false
  end
end
