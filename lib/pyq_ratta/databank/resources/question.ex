defmodule PyqRatta.Databank.Question do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    uuid_primary_key :id

    attribute :question_text, :string, allow_nil?: true
    attribute :question_image, :string, allow_nil?: true

    attribute :type, :string

    attribute :correct_answer_text, :string, allow_nil?: false
    attribute :correct_answer_image, :string, allow_nil?: true

    attribute :explanation_text, :string, allow_nil?: true
    attribute :explanation_image, :string, allow_nil?: true

    attribute :short_description, :string, allow_nil?: true
    attribute :long_description, :string, allow_nil?: true
    attribute :year, :integer, allow_nil?: true
    attribute :tags, {:array, :string}, default: []

    create_timestamp :created_at
    create_timestamp :updated_at
  end

  relationships do
    many_to_many :quizzes, PyqRatta.Databank.Quiz do
      through PyqRatta.Databank.QuizQuestion
      source_attribute_on_join_resource :question_id
      destination_attribute_on_join_resource :quiz_id
    end
  end

  postgres do
    table "question"
    repo PyqRatta.Repo
  end

  code_interface do
    define_for PyqRatta.Databank

    define :create, action: :create
    define :read, args: [:question_id]
    define :all
    define :update
  end

  actions do
    defaults [:update, :create, :destroy]

    read :all

    read :read do
      argument :question_id, :uuid do
        allow_nil? false
      end

      # to indicate that only one record will be returned
      get? true
      primary? true

      filter expr(id == ^arg(:question_id))
    end
  end
end
