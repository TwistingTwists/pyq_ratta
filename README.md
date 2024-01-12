# PyqRatta

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

2024-01-07

## v0.1.2

Creating APIs

------------

[ ] Accounts.User - login with telegram / google (with identities?)

------------

[ ] Quiz Interface

    [x] `Databank.Quiz.create_quiz(questions: [%{text: "asdf", image: "image/url/to/save/in/db", correct_answer: "A"},%{text: "second question", image: "image/url/to/save/in/db", correct_answer: "B"} ])`
    [x] Databank.Quiz.add_questions(questions: [1,2,3])

    [ ] Create a User
    [ ] Create a quiz based on (a) wrong questions for user: 2 , quiz_id: 2
        [ ] Quiz.create_for_user(actor: user, quiz_id: 2, type: :wrong_only)
        [ ] type: [:wrong_only, :new , :difficult_only]
    [ ] User can answer a question from a quiz - and response is recorded in QuizPractice.Response
        [ ] QuizPractice.Response.save(question, quiz, user, "A")
    [ ] Get Next Question for the user
        [ ] Quiz.next_question(quiz, user)
            -> reads the latest Response by the user (Cachex { v0.3 })
            -> Read next question in Quiz, [order_by: :created_at] (Cachex { v0.3 })
            ->

------------

[ ] Running quiz (ExGram)

    [ ] Scenario 1 : A quiz is run for all users. Irrespective of they join when. More like competition mode.
        [ ] A QuizSession is started (ets backed). One or more users can join   it.

    [x] Scenario 2 : Users can take a quiz when they are feel like it.
        [ ] Each User has `UserAttemptServer` which manages the next question, response to previous question, timeouts.
            [ ] Use AshStateMachine or GenStateMachine to manage quiz for the user. Use Ets data layer.
            [ ] Hibernate the genserver if not being actively used.  { v0.3 }
        [ ] TelegramBot.send_message(bot,chat_id,msg)




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
