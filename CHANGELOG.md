

### v0.2

Features:
[ ] Analytics on 'wrong' questions and reminders
[ ] Caching for
    [ ] Current User
    [ ] File being sent to the user - use file_id of telegram, not {:file, "local/file/path"}
[ ] UI to monitor realtime progress of each user
[ ] Make learning sharable.
    [ ] post in group - leaderboard
    [ ] LiveLink to show leaderboard

2024-02-20

### v0.1.4

[ ] Create a quiz based on (a) wrong questions for user: 2 , quiz_id: 2
    [ ] Quiz.create_for_user(actor: user, quiz_id: 2, type: :wrong_only)
    [ ] type: [:wrong_only, :new , :difficult_only]

#### Telegram:
[ ] what is chatinstance?
[ ] Some telemetry for saving all incoming / outgoing messages from telegram - to clickhouse?
    [ ] databse ?
    [ ] aim? - discoverability
[ ] User responses are buffered via Throttle Adapter.
    [] Buffer out all the responses of the user to a single process which then flushes them to the tg client to proper rate limits.


#### Running Quiz:

#### Database:
[ ] User can answer a question from a quiz - and response is recorded in QuizPractice.Response
    [x] QuizPractice.Response.save(question, quiz, user, "A")



2024-01-19

## v0.1.3

#### Telegram:
[x] Button and keyboard in telegram -- how to respond
[x] Answer to previous question is sent before the next question is sent.

#### Running Quiz:
[x] Shutdown the server for the paid user_id, quiz_id
[x] Shutdown the UserAttemptServer and callback terminate function in it.

#### Database:
[ ] User can answer a question from a quiz - and response is recorded in QuizPractice.Response
    [x] QuizPractice.Response.save(question, quiz, user, "A")


2024-01-07

## v0.1.2

Creating APIs

------------

[x] Accounts.User - login with telegram / google (with identities?)

------------

[ ] Quiz Interface

    [x] `Databank.Quiz.create_quiz(questions: [%{text: "asdf", image: "image/url/to/save/in/db", correct_answer: "A"},%{text: "second question", image: "image/url/to/save/in/db", correct_answer: "B"} ])`
    [x] Databank.Quiz.add_questions(questions: [1,2,3])

    [x] Create a User
    [x] Get Next Question for the user
        [x] Quiz.next_question(quiz, user)
            -> reads the latest Response by the user (Cachex { v0.3 })
            -> Read next question in Quiz, [order_by: :created_at] (Cachex { v0.3 })

------------

[ ] Running quiz (ExGram)

    [ ] Scenario 1 : A quiz is run for all users. Irrespective of they join when. More like competition mode.
        [ ] A QuizSession is started (ets backed). One or more users can join   it.

    [x] Scenario 2 : Users can take a quiz when they are feel like it.
        [x] Each User has `UserAttemptServer` which manages the next question, response to previous question, timeouts.
            [ ] Use AshStateMachine or GenStateMachine to manage quiz for the user. Use Ets data layer.
            [ ] Hibernate the genserver if not being actively used.  { v0.3 }
        [x] TelegramBot.send_message(bot,chat_id,msg)
