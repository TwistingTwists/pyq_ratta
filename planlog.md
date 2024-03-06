### feedback for v1.0.0

use Ash.Reactor?
https://github.com/ash-project/ash/pull/683/files#diff-a80a3b8c6d3b9d582afa791b2e44f12141439879039006919dcce58b545b8457


### context to send to chatgpt 
```
main	quiz_questions	table	3	0	0
main	user_quiz_response	table	7	0	0
main	users	table	9	0	0
main	quiz	table	7	0	0
main	question	table	15	0	0
main	schema_migrations	table	2	0	0


This is the short table form description of the database schema. 

 foreign keys are as follows.
  user_quiz_response.question_id => question.id
  user_quiz_response.quiz_id => quiz.id
  user_quiz_response.user_id => users.id
  quiz_questions.question_id => question.id
  quiz_questions.quiz_id => quiz.id


--- 
Write an SQL query to list the number of students who have taken latest quiz

```

### Increase engagement 

1. Prompt at most active and least active times? 
    * Activity in group, join/leave time, post time
2. Most active (quiz) - updates to #n people completed! 
3. Live Dashboard - on website? 
    #users who attempted question 1 - Realtime
4. 


### Analytics / Reminders

[ ] UI to monitor realtime progress of each user
[ ] Make learning sharable.
    [ ] post in group - leaderboard
    [ ] LiveLink to show leaderboard

[ ] Analytics

    [ ] on 'wrong' questions and reminders
    
    [ ] (personal) leaderboard at the end of quiz - how many questions they got right?

    [ ] (personal) consent - include in public leaderboard?

    [ ] users began vs finished

    [ ] public leaderboard


#### Logging Observability

https://dev.to/christianalexander/async-elixir-telemetry-2llo
https://davelucia.com/blog/observing-elixir-with-lightstep
https://hexdocs.pm/sibyl/Sibyl.html



[x] LoggerFileBackend
    [x] can backup to telegram channel
    [ ] ingest to openobserve via HTTP

[ ] getting started with open telemetry
   [x] installation
   [ ] OTEL for -> phoenix and ecto only.
   [ ] Custom OTEL
    [ ] Elixir Tempo Grafana Loki backend

[ ] PromEx ?

[ ] Postgres Setup
    [ ] with backups to s3
    https://elephant-shed.io/#download

[ ] telemetry basic setup
        [ ] Jason.Encode for Ash Resources - Medea.Formatter
        [ ] trace / span / and grafana cloud! 



### QuizRunner 

    [ ] Total Question Count before quiz
    [ ] (bug) If user starts a new quiz when old one is already running? 
    -> kill old one and start new one.

    [ ] (enhancement) What if server crashes when the user is taking the quiz? 
    [ ] (enhancement) sending file from disk
        [ ] send once and capture file_id in database column? -> then use that subsequently => not more uploading files again and again to telegram

    [x] Shutdown genserver properly 
    [x]  - parting message?

    [ ] Buffered sender to telegram
        [x] basic implementation 
        [ ] write to disk if BufferedSender Crashes and recover from disk? 

    [ ] cache users crashes?


    [ ] What if server closes down during quiz?
        -> if a response comes for a user who hasn't started a quiz => ask to restart quiz by clicking on link again.


### Prepare Quiz 

    [ ] (bug) message reply_to in channel
    
    [x] link to quiz in channel
    [x] Question in Order please
    [x] For detailed explanations visit: 
    [x] Quiz will be ready in 5min.
    [ ] solution screenshot?



### scrape
https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=ef1ebda70145fa7fd0da9e00e23b8384cc685e22
https://eli.thegreenplace.net/2010/01/02/top-down-operator-precedence-parsing/
https://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/
https://abarker.github.io/typped/pratt_parsing_intro.html

[x] get correct answer from browser
    wpProQuiz_questionListItem wpProQuiz_answerCorrect -> read attribute-> data-post="1"
[x] send to elixir
[x] parse and create questions!
[x] post the link back to telegram


### v0.4

Stream pdf to the url
[ ] https://github.com/agentcooper/react-pdf-highlighter
[ ] https://stephenbussey.com/2022/04/13/react-in-liveview-how-and-why.html
[ ] Stephen bussey suggested - https://github.com/UgnisSoftware/react-spreadsheet-import
[ ] pdf as images. meh.  https://github.com/wojtekmaj/react-pdf
[] generate pdf -> https://pdfme.com/docs/getting-started


### v0.3

[ ] Storage
    [ ] postgres local with s3 backups (genserver based)
    [ ] cloudflare account - for postgres backups and images

[ ] Process the link for daily MCQ
    [ ] take screenshot of all files
    [ ] receive json from python
    [ ] Put quiz / question in db
    [ ] generate telegram link and reply to the post

[x] Save the response in database

[ ] Performance Improvements
    [ ] File being sent to the user - use file_id of telegram, not {:file, "local/file/path"}


### v0.2

Features:
[ ] Caching for
    [x] Current User


### v0.1.4

[ ] Create a quiz based on (a) wrong questions for user: 2 , quiz_id: 2
    [ ] Quiz.create_for_user(actor: user, quiz_id: 2, type: :wrong_only)
    [ ] type: [:wrong_only, :new , :difficult_only]

#### Telegram:
[ ] what is chatinstance?
[ ] Some telemetry for saving all incoming / outgoing messages from telegram - to clickhouse?
    [ ] databse ?
    [ ] aim? - discoverability
    [ ] see reference implementation - https://github.com/rockneurotiko/ex_gram/issues/106 + https://github.com/rockneurotiko/ex_gram/pull/97
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
