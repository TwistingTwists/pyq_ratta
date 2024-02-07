defmodule PyqRatta.QuizPractice.Response do
  require Logger

  alias PyqRatta.Databank.Changes.AddArgToRelationship
  alias PyqRatta.QuizPractice.Changesets.UserTgIdtoUserId

  use Ash.Resource,
    data_layer: AshPostgres.DataLayer

  code_interface do
    define_for PyqRatta.QuizPractice

    define :save, action: :save, args: [:user_tg_id, :quiz_id, :question_id]
    define :of_user_tgid, args: [:telegram_id]
    define :of_user_userid
  end

  actions do
    defaults [:read, :update]
    # defaults [:read, :update, :create]

    read :of_user_tgid do
      argument :telegram_id, :decimal, allow_nil?: false
      # filter expr(user_id == ^actor(:id))
      prepare fn query, context ->
        Ash.Query.before_action(query, fn query ->
          query |> IO.inspect(label: "this is query")

          # Ash.Query.set_result(query, {:ok, results})
        end)
      end
    end

    read :of_user_userid do
      filter expr(user_id == ^actor(:id))
    end

    create :save do
      argument :user_tg_id, :decimal do
        allow_nil? false
      end

      argument :quiz_id, :uuid do
        allow_nil? false
      end

      argument :question_id, :uuid do
        allow_nil? false
      end

      change set_attribute(:quiz_id, arg(:quiz_id))
      change set_attribute(:question_id, arg(:question_id))
      change {UserTgIdtoUserId, arg: :user_tg_id, attr: :user_id}
    end

    #     #       read :next do
    #     #         get? true

    #     #         prepare build(limit: 1, sort: [retry_at: :asc])

    #     #         filter expr(user_id == ^actor(:id) and retry_at <= now())

    #     #         prepare fn query, context ->
    #     #           Ash.Query.after_action(query, fn
    #     #             _, [] ->
    #     #               Logger.debug("No cards due 📭")

    #     #               reviewed_today_count =
    #     #                 Red.Accounts.load!(
    #     #                   context.actor,
    #     #                   [:count_cards_reviewed_today]
    #     #                 ).count_cards_reviewed_today

    #     #               if reviewed_today_count < context.actor.daily_goal do
    #     #                 Logger.debug("Grabbing a new card ✨")
    #     #                 Card.oldest_untried_card(actor: context.actor)
    #     #               else
    #     #                 Logger.debug("Looking Ahead 🔭")
    #     #                 Card.lookahead(actor: context.actor)
    #     #               end

    #     #             _, results ->
    #     #               Logger.debug("A card was found with retry_at <= now ✅")
    #     #               {:ok, results}
    #     #           end)
    #     #         end
    #     #   end

    #     #     #   read :lookahead do
    #     #     #     prepare build(limit: 1, sort: [retry_at: :asc])

    #     #     #     filter expr(user_id == ^actor(:id) and retry_at <= from_now(20, :minute))
    #     #     #   end

    #     #     #   read :oldest_untried_card do
    #     #     #     prepare build(limit: 1, sort: [created_at: :asc])

    #     #     #     filter expr(is_nil(retry_at) and user_id == ^actor(:id))
    #     #     #   end

    #     #     #   read :get_by do
    #     #     #     filter expr(user_id == ^actor(:id))
    #     #     #     get_by [:word]
    #     #     #   end

    #     #     #   update :try do
    #     #     #     accept [:tried_spelling]
    #     #     #     argument(:tried_spelling, :string, allow_nil?: false)
    #     #     #     manual Red.Practice.Card.Try
    #     #     #   end
    #   end

    #   #     # calculations do
    #   #     #   calculate :interval_in_seconds,
    #   #     #             :integer,
    #   #     #             expr(fragment("EXTRACT(EPOCH FROM ?)", retry_at - tried_at))
  end

  attributes do
    # integer_primary_key :id
    uuid_primary_key :id

    #       attribute :correct_streak, :integer, allow_nil?: false, default: 0
    attribute :attempted_answer, :string, allow_nil?: false
    attribute :retry_at, :utc_datetime, allow_nil?: true
    #       attribute :word, :string, allow_nil?: false

    # response cannot be edited. so, created_at == tried_at
    create_timestamp :created_at
  end

  # identities do
  #   identity :unique_response, [:quiz_id, :question_id]
  # end

  relationships do
    belongs_to :user, PyqRatta.Accounts.User,
      api: PyqRatta.Accounts,
      attribute_writable?: true,
      allow_nil?: false

    belongs_to :quiz, PyqRatta.Databank.Quiz,
      api: PyqRatta.Databank,
      attribute_writable?: true,
      allow_nil?: false

    belongs_to :question, PyqRatta.Databank.Question,
      api: PyqRatta.Databank,
      attribute_writable?: true,
      allow_nil?: false
  end

  postgres do
    table "user_quiz_response"
    repo PyqRatta.Repo
  end
end
