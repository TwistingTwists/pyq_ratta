alias PyqRatta.Databank.Quiz
alias PyqRatta.Databank.Question
alias PyqRatta.Databank.QuizQuestion
alias PyqRatta.Accounts
alias PyqRatta.Accounts.User
alias PyqRatta.QuizPractice.Response, as: UserResponse
alias PyqRatta.QuizPractice.Response
alias PyqRatta.Workers.UserAttemptServer, as: UAS
alias PyqRatta.Factory

alias DynamicSupervisor, as: DS
DS.which_children(PyqRatta.Telegram.Commands.DynamicSupervisor)
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

quiz_id = "55e8278b-3646-42e4-8ccf-1374d42f2607"
question_id = "846b9758-67b2-4bf1-8a16-3e574686904c"
user_response = "b"
# UserResponse.save(me_tg_id,   quiz_id, question_id, %{attempted_answer: user_response})

UserResponse
|> Ash.Changeset.new()
|> Ash.Changeset.set_argument(:user_id, me_tg_id)
|> Ash.Changeset.set_argument(:question_id, question_id)
|> Ash.Changeset.set_argument(:quiz_id, quiz_id)

# |> Ash.Changeset.for_create(:save)

# Response.of_user_tgid(me_tg_id)
#   |> IO.inspect(label: "Reponse for the telegram user")

Response.of_user_tgid(me_tg_id)

##### struct works #####

# defmodule H do

#   use TypedStruct

#     typedstruct enforce: true , visibility: :opaque , module: State do
#       @moduledoc "Internal state -- used to ensure that user_id and quiz_id are non_nil at all times."
#       field :user_id, String.t()
#       field :quiz_id, String.t()
#     end

# end
# opts = [user_id: " as", quiz_id: "asdf", a: "asdfff"]
# struct(H.State, Map.new(opts))

Logger.configure(level: :warning)
