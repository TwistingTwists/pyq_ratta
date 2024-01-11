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

    # references do
    #   reference :quiz, on_delete: :delete, on_update: :update
    # end
  end

  code_interface do
    define_for PyqRatta.Databank

    define :create, action: :create
    define :read, args: [:question_id]
    define :all
    define :update
    # define :for_user, action: :for_user
    # define :get_by, action: :get_by
    # define :lookahead, action: :lookahead
    # define :next, action: :next
    # define :oldest_untried_card, action: :oldest_untried_card
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

    # update :update do
    #   primary? true

    #   argument :quiz_id, :integer do
    #      allow_nil? false
    #   end

    #   change manage_relationship(:quiz, type: :direct_control)
    # end
  end
end
