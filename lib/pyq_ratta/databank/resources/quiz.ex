defmodule PyqRatta.Databank.Quiz do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  alias PyqRatta, as: PR

  alias __MODULE__
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion

  attributes do
    uuid_primary_key :id

    attribute :short_description, :string, allow_nil?: true
    attribute :long_description, :string, allow_nil?: true

    attribute :year, :integer, allow_nil?: true
    attribute :tags, {:array, :string}, default: []

    create_timestamp :created_at
    create_timestamp :updated_at
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
    define :read, args: [:quiz_id]
  end

  actions do
    defaults [:create, :update]

    read :all, primary?: true

    read :read do
      argument :quiz_id, :uuid do
        allow_nil? false
      end

      # prepare fn query, _ ->
      #   query
      #   |> Ash.Query.load([:questions])
      # end

      # to indicate that only one record will be returned
      get? true

      filter expr(id == ^arg(:quiz_id))
    end

    create :create_quiz_from_questions do
      accept []

      argument :questions, {:array, :map} do
        allow_nil? false
      end

      # change {PyqRatta.Databank.Changes.AddArgToRelationship, arg: :quiz_id, rel: :questions}
      change manage_relationship(:questions, type: :direct_control)
    end

    update :update_quiz_with_question_ids do
      accept []

      argument :question_ids, {:array, :uuid} do
        allow_nil? false
      end

      change manage_relationship(:question_ids, :questions, type: :append_and_remove)
    end

    # update :update_quiz_with_question_ids do
    #   accept []

    #   argument :question_ids, {:array, :uuid} do
    #     allow_nil? false
    #   end

    #   # change fn changeset, _ ->
    #   #   Ash.Changeset.after_action(changeset, fn changeset, quiz ->
    #   # question_ids = Ash.Changeset.get_argument(changeset, :question_ids)

    #   manual PR.Databank.Manual.UdpateQuiz
    # end

    # update :update_quiz_with_question_ids do
    #   accept []

    #   argument :question_ids, {:array, :uuid} do
    #     allow_nil? false
    #   end

    #   manual PyqRatta.Databank.Manual.UpdateQuiz
    # end

    # update :add_question_ids do
    #   argument :question_ids, {:array, :integer} do
    #     allow_nil? false
    #     # only applicable for {:array, :integer} (array types)
    #     constraints min_length: 1
    #   end

    #   # change {PyqRatta.Databank.Changes.AddArgToRelationship, rel: :questions}

    #   # change manage_relationship(:question_ids, :questions, type: :direct_control)
    #   change before_action(fn changeset ->
    #            quiz_id = changeset.data.id

    #            question_ids =
    #              Ash.Changeset.get_argument(changeset, :question_ids)
    #              |> IO.inspect(label: "Questions IDS are these")

    #            # fetch all questions and manually put quiz_id in them.

    #            joins =
    #              Enum.map(question_ids, fn question_id ->
    #                with {:ok, question} <- PR.Databank.Question.read(question_id) do
    #                  Map.put(question, :quiz_id, quiz_id)
    #                else
    #                  _ -> nil
    #                end
    #              end)
    #              |> Enum.filter(fn x -> !is_nil(x) end)

    #            changeset
    #            |> Ash.Changeset.manage_relationship(
    #              :questions,
    #              joins,
    #              type: :direct_control
    #              #  on_lookup: :ignore,
    #              #  on_no_match: :create,
    #              #  on_match: :update,
    #              #  on_missing: :destroy
    #            )
    #            |> IO.inspect(label: "Final CS")
    #          end)

    #   # change manage_relationship(:questions, type: :direct_control)

    #   # manual PyqRatta.Quiz.Question.Changeset
    #   # change set_attribute(:question_id, arg(:question_id))
    # end
  end
end
