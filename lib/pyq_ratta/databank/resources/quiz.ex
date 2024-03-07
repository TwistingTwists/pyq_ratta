defmodule PyqRatta.Databank.Quiz do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  alias PyqRatta, as: PR

  alias __MODULE__
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion

  @load_fields [:questions, :question_count]

  attributes do
    uuid_primary_key :id

    attribute :short_description, :string, allow_nil?: true
    attribute :long_description, :string, allow_nil?: true

    attribute :year, :integer, allow_nil?: true
    attribute :tags, {:array, :string}, default: []

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  aggregates do
    count :question_count, :questions
  end

  relationships do
    many_to_many :questions, PyqRatta.Databank.Question do
      through PR.Databank.QuizQuestion
      source_attribute_on_join_resource :quiz_id
      destination_attribute_on_join_resource :question_id
    end
  end

  postgres do
    table "quiz"
    repo PyqRatta.Repo
  end

  code_interface do
    define_for PyqRatta.Databank

    define :create_quiz_from_questions, args: [:questions]
    define :create
    define :all
    define :update_quiz_with_question_ids, args: [:question_ids]
    # define :update_quiz_with_question_id, args: [:question_id]
    define :read_by_id, args: [:quiz_id]
  end

  actions do
    defaults [:read, :create, :update]

    read :all

    read :read_by_id do
      argument :quiz_id, :uuid do
        allow_nil? false
      end

      # to indicate that only one record will be returned
      get? true

      filter expr(id == ^arg(:quiz_id))

      prepare build(load: @load_fields)
    end

    create :create_quiz_from_questions do
      accept []

      argument :questions, {:array, :map} do
        allow_nil? false
      end

      # change {PyqRatta.Databank.Changes.AddArgToRelationship, arg: :quiz_id, rel: :questions}
      # change manage_relationship(:questions, type: :direct_control)
      change manage_relationship(:questions,
               on_lookup: :ignore,
               on_no_match: {:create, :create, :relate, [:quiz_id, :question_id, :question_number]},
               on_match: :update,
               on_missing: :destroy
             )
    end

    update :update_quiz_with_question_ids do
      accept []

      argument :question_ids, {:array, :uuid} do
        allow_nil? false
      end

      change manage_relationship(:question_ids, :questions, type: :append)
    end
  end

  def sort_question_order(quiz) do
    qid = quiz.id
    {:ok, qq_join_table} = QuizQuestion.read_by_quiz_id(%{quiz_id: qid})

    question_ids = Enum.map(qq_join_table, & &1.question_id)

    Enum.reduce(question_ids, [], fn qid, acc ->
      question = Enum.find(quiz.questions, fn q -> q.id == qid end)
      [question | acc]
    end)
  end
end
