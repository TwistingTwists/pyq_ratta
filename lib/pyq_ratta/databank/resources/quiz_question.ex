defmodule PyqRatta.Databank.QuizQuestion do
  @moduledoc """
  The join resource between Quiz and Question
  """
  use Ash.Resource, data_layer: AshPostgres.DataLayer

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question

  attributes do
    attribute :question_number, :integer
    # , allow_nil: false
  end

  code_interface do
    define_for PyqRatta.Databank
    define :relate, args: [:quiz_id, :question_id, :question_number]
    # define :create_with_qnum, args: [:quiz_id, :question_id, :question_number]
    define :update, action: :update_qnum
    define :read
  end

  actions do
    defaults [:create, :read, :update, :destroy]

    create :relate do
      upsert? true
    end

    # create :create_with_qnum do  
    #   argument :question_id , :uuid 
    #   argument :quiz_id , :uuid 
    #   argument :question_number, :integer

    # end

    update :update_qnum do 
      accept [:question_number]
      # upsert? true
    end

  end

  postgres do
    table "quiz_questions"
    repo PyqRatta.Repo

    references do
      reference :quiz, on_delete: :delete
      reference :question, on_delete: :delete
    end
  end

  relationships do
    belongs_to :quiz, Quiz, primary_key?: true, allow_nil?: false
    belongs_to :question, Question, primary_key?: true, allow_nil?: false
  end
end
