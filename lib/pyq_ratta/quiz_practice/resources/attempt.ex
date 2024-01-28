defmodule PyqRatta.QuizPractice.UserAttempt do
  use Ash.Resource,
    extensions: [AshStateMachine],
    data_layer: Ash.DataLayer.Ets

  # data_layer: AshPostgres.DataLayer

  alias __MODULE__
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.QuizQuestion
  alias PyqRatta.QuizPractice.Response

  # start -> send_next_question -> send_results -> stop

  state_machine do
    initial_states([:start])
    default_initial_state(:start)

    transitions do
      transition(:begin_quiz, from: :start, to: :send_next_question)
      transition(:continue_quiz, from: :send_next_question, to: :send_next_question)
      transition(:process_results, from: :send_next_question, to: :send_results)
      transition(:error, from: [:start, :send_next_question, :send_results], to: :stop)
    end
  end

  actions do
    # create sets the state
    defaults [:create, :read]

    update :begin_quiz do
      # change relate_actor(:user)
      change transition_state(:send_next_question)
    end

    update :continue_quiz do
      # accept [:current_response]

      # change transition_state(:send_next_question)
      # change UserAttempting.Changeset.SendNextOrResult
    end

    update :process_results do
      # accept [...]
      change transition_state(:send_results)
    end

    update :error do
      accept [:error_state, :error]
      change transition_state(:stop)
    end
  end

  changes do
    # any failures should be captured and transitioned to the error state
    change after_transaction(fn
             changeset, {:ok, result} ->
               {:ok, result}

             changeset, {:error, error} ->
               message = Exception.message(error)

               changeset.data
               |> Ash.Changeset.for_update(:error, %{
                 message: message,
                 error_state: changeset.data.state
               })
               |> Api.update()
           end),
           on: [:update]
  end

  attributes do
    uuid_primary_key :id

    # default id should be there.
    attribute :quiz_id, :uuid, allow_nil?: false
    attribute :user_id, :uuid, allow_nil?: false

    # I want to run one UserAttempting per user
    attribute :quiz, :map, allow_nil?: true
    attribute :user, :map, allow_nil?: true

    # reponse for the question
    attribute :current_response, :string, allow_nil?: true
    attribute :previous_question, :uuid, allow_nil?: true
    attribute :next_question, :uuid, allow_nil?: true

    # show errors
    attribute :error, :string
    attribute :error_state, :string
    # :state attribute is added for you by `state_machine`
    # however, you can add it yourself, and you will be guided by
    # compile errors on what states need to be allowed by your type.
  end
end
