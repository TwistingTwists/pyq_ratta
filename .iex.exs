alias PyqRatta.Databank.Quiz
alias PyqRatta.Databank.Question
alias PyqRatta.Factory
alias PyqRatta.Databank.QuizQuestion
alias PyqRatta.Accounts
alias PyqRatta.QuizPractice.Response

# %{type: type, question_text: question_text} =
#   question_params =
#   [
#     %{
#       question_text: "First question",
#       question_image: "image/url/to/save/in/db",
#       correct_answer_text: "A",
#       type: "MCQ"
#     }
#   ]
#   |> hd()

# {:ok, %{type: ^type, question_text: ^question_text, id: id}} =
#   Question.create(question_params)

# defmodule Test do
#   alias PyqRatta.Databank.Quiz
#   alias PyqRatta.Databank.Question

#   questions_params_list = [
#     %{
#       question_text: "First question",
#       question_image: "image/url/to/save/in/db",
#       correct_answer_text: "A",
#       type: "MCQ"
#     },
#     %{
#       question_text: "second  question",
#       question_image: "image/url/to/save/in/db",
#       correct_answer_text: "B",
#       type: "MCQ"
#     }
#   ]

#   def run do
#     questions_params_list = questions_list_params()

#     questions_in_db =
#       Enum.reduce(questions_params_list, [], fn question_params, acc ->
#         {:ok, question} = Question.create(question_params)
#         acc ++ [question]
#       end)

#     qids = Enum.map(questions_in_db, & &1.id)

#     {:ok, empty_quiz} = Quiz.create()

#     {:ok, %{id: quiz_id}} =
#       Quiz.update_quiz_with_question_ids(empty_quiz, qids)
#       |> IO.inspect(label: "update_quiz_with_question_ids", limit: :infinity)

#     {:ok, quiz} =
#       Quiz.read(quiz_id)
#   end
# end

# require Ash.Query

# change manage_relationship(:question_ids, :questions, type: :append_and_remove)
# https://hexdocs.pm/ash/Ash.Changeset.html#manage_relationship/4

# change manage_relationship(:question_ids, :questions,
#          on_match: :ignore,
#          on_lookup: :relate,
#          on_no_match: :relate,
#          # since we are adding more questions to the quiz.
#          on_missing: :ignore
#        )

# change manage_relationship(:question_ids, :questions, type: :direct_control)
me_tg_id = 417_851_214

# Response.of_user_tgid(me_tg_id)
#   |> IO.inspect(label: "Reponse for the telegram user")


Response.of_user_tgid(me_tg_id)
