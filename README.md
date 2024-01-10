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

[ ] Databank.create_quiz(questions: [%{text: "asdf", image: "image/url/to/save/in/db", correct_answer: "A"},%{text: "second question", image: "image/url/to/save/in/db", correct_answer: "B"} ])
[ ] Databank.Quiz.add_questions(questions: [1,2,3])

[ ] Accounts.User - login with google (with identities?)

[ ] ExGram for running quiz
    [ ] QuizPractice.create(actor: user, quiz_id: 2, type: :wrong)
    [ ] if :user  is given, run the quiz (quiz_id: 2) for the user, else try to find quiz.user
    [ ] type: [:wrong_only, :new , :difficult_only]

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
