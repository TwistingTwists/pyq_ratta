# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PyqRatta.Repo.insert!(%PyqRatta.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias PyqRatta.Databank.Quiz
alias PyqRatta.Databank.Question
alias PyqRatta.Databank.QuizQuestion
alias PyqRatta.QuizPractice.Response
alias PyqRatta.Accounts


# create questions
 question_params = [%{
   question_text: "First question seeds.exs",
   question_image: "image/url/to/save/in/db",
   correct_answer_text: "A",
   type: "MCQ"
 },%{
   question_text: "second question seeds.exs",
   question_image: "image/url/to/save/in/db",
   correct_answer_text: "B",
   type: "MCQ"
 },%{
   question_text: "third question seeds.exs",
   question_image: "image/url/to/save/in/db",
   correct_answer_text: "B",
   type: "MCQ"
 }]

 questions = Enum.map( question_params , fn qparam ->
{:ok, question } =  Question.create(qparam)
question
end)

# create quiz

{:ok, empty_quiz} = Quiz.create()

# add questions to quiz

qids = Enum.map(questions, & &1.id)
Quiz.update_quiz_with_question_ids(empty_quiz, qids)

# create user
tg_id = 100
{:ok, user} = Accounts.User.register_with_telegram(tg_id)

# create response for the (question, quiz,user)

Response.save(%{quiz_id: empty_quiz.id, question_id: Enum.at(questions, 2).id, attempted_answer: "Z"} , actor: user)
