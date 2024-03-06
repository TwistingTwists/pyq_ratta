 DailyQuizForYouBot
# PyqRatta

### Runtime Analysis
DynamicSupervisor.count_children(PyqRatta.Telegram.Commands.DynamicSupervisor)

user_pids = DynamicSupervisor.which_children(PyqRatta.Telegram.Commands.DynamicSupervisor) |> Enum.map(fn {:undefined, pid, _, _} -> pid end )

user_pid = hd(user_pids )

{_, _, _, state} = :sys.get_status(user_pid)


Keyword.pop(genserver_state, :data)



## Notes from AshHq

* channnel has_many thread
* thread has_many messages
* thread many_to_many tags
---> cascading actions in ash <----
* message has_many attachments, reactions
    references thread
* reactions
    references message
* attachments
    references message

    Here is the scenario :

    1. a quiz has_many questions
    2. a user wants to attempt a quiz. UserStateMachine (USM, for short) will manage the session for the user
    3. USM loads all the questions for the quiz and sets in `:start` state.
    `  start -> send_next_question -> send_results -> stop`
    ```elixir

      state_machine do
        initial_states [:start]
        default_initial_state :start

        transitions do
          transition :begin_quiz, from: :start, to: :send_next_question
          transition :continue_quiz, from: :send_next_question, to: :send_next_question
          transition :send_results, from: :send_next_question, to: :send_results
          transition :error, from: [:start, :send_next_question, :sent_results], to: :stop
        end
      end
    ```

2024-01-06

### Deployment

[ ] postgres backups?
[ ] deploying via scripts?
[ ] Monitoring - https://github.com/florinpatrascu/elixir_grafana_loki_tempo?tab=readme-ov-file
[ ] attached livebook instance


2024-01-05

## V0.1

[x] Upload Bulk images at once
  * those are question images

2024-01-04

[x] User can upload images - in bulk and they are saved in priv folder.


user:
  name
  email
  hashed_password
  has_many quiz_attempts


~~question: ~~
  question_text
  question_images

  type

  correct_answer_text
  correct_answer_image

  explanation_text
  explanation_image

  short_description
  long_description


prelims_pyq:
  year
  has_many questions


quiz:
  short_description
  long_description
  personalised_for {:array, :user_id}
  has_many tags
  has_many questions


question_attempt:
  answer_marked
  answer_correct
  belongs_to question_id
  belongs_to user


quiz_attempt:
  belongs_to user
  belongs_to quiz_id
  has_many


tags:
  name
  created_by [ :user_id, :system]


What are the queries?

1. How many users attempted this quiz? List.
2.
