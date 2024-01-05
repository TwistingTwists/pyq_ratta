defmodule PyqRatta.Quiz.Question do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key :id

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

  postgres do
    table "question"
    repo PyqRatta.Repo
  end

  code_interface do
    define_for PyqRatta.Quiz

    define :create, action: :create
    # define :for_user, action: :for_user
    # define :get_by, action: :get_by
    # define :lookahead, action: :lookahead
    # define :next, action: :next
    # define :oldest_untried_card, action: :oldest_untried_card
  end

  actions do
    defaults [:read, :update, :create]
  end
end
