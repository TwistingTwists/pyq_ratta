defmodule PyqRatta.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      # AshAuthentication,
      AshAdmin.Resource
    ]

  admin do
    actor?(true)
  end

  attributes do
    # integer_primary_key :id
    uuid_primary_key :id

    attribute :email, :ci_string
    # attribute :auth0_id, :string, allow_nil?: false, private?: true
    attribute :telegram_id, :decimal, allow_nil?: false, private?: true
    attribute :email_verified, :boolean
    attribute :tg_firstname, :ci_string
    attribute :tg_lastname, :ci_string
    attribute :daily_goal, :integer, default: 10

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :responses, PyqRatta.QuizPractice.Response, api: PyqRatta.QuizPractice
  end

  postgres do
    table "users"
    repo PyqRatta.Repo
  end

  identities do
    # identity :unique_email, [:email]
    identity :unique_telegram_id, [:telegram_id]
  end

  actions do
    defaults [:read, :update]

    create :register_with_telegram do
      argument :telegram_id, :decimal, allow_nil?: false
      upsert? true
      upsert_identity :unique_telegram_id

      # todo: better way but works.
      change fn cs, _ ->
        tg_id = Ash.Changeset.get_argument(cs, :telegram_id)
        Ash.Changeset.change_attribute(cs, :telegram_id, tg_id)
      end
    end

    read :get_by do
      get_by :telegram_id
    end
  end

  code_interface do
    define_for PyqRatta.Accounts

    define :get_by, action: :get_by
    define :register_with_telegram, args: [:telegram_id]
  end
end
