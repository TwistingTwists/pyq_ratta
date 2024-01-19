# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs

alias PyqRatta.Databank.Quiz
alias PyqRatta.Databank.Question
alias PyqRatta.Databank.QuizQuestion
alias PyqRatta.QuizPractice.Response
alias PyqRatta.Accounts

# create questions
question_params = [
%{question_text: " question 1", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.55.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 1", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.59.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 2", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.58.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 3 ", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.54.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 4", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.57.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 5", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.32.56.jpeg",correct_answer_text: "A",type: "MCQ"},
%{question_text: " question 6", question_image: "/Users/abhishek/Downloads/telegram/database_qs/photo_2024-01-19_16.33.00.jpeg",correct_answer_text: "A",type: "MCQ"}]


questions =
  Enum.map(question_params, fn qparam ->
    {:ok, question} = Question.create(qparam)
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

Response.save(
  %{quiz_id: empty_quiz.id, question_id: Enum.at(questions, 2).id, attempted_answer: "Z"},
  actor: user
)
