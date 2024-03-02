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

# Logger.configure(level: :warning)


alias PyqRatta.Telegram.BufferedSender, as: TgSender
# TgSender.queue(6285379293, " Quiz Finished. Enjoy!\n", [parse_mode: "Markdown"])


alias PyqRatta.Databank.QuizQuestion, as: QQ 
# quiz_id = "dcb79a1c-878e-4a27-a911-64dd75a74add"
# question_id = ""
# quiz_question = QQ.read(qq_id)
# QQ.update(quiz_question, 4)


# QQ.create(%{quiz_id: "dcb79a1c-878e-4a27-a911-64dd75a74aed" , question_id: "dcb79a1c-878e-4a27-a911-64dd75a74aqq" , question_number: 1})



# Quiz.create_quiz_from_questions([ 
#     %{
#         "source" => "https://www.pmfias.com/ppqs-january-05-2024/",
#         "question_number" => 1,
#         "short_description" => "January 05 2024 Prelims Practice Questions (PPQs)",
#         "question_image" => "/Users/abhishek/Downloads/perps/prelims_portal/pyq_ratta/_build/dev/lib/pyq_ratta/priv/python/screenshots/January 05 2024 Prelims Practice Questions (PPQs)/quiz_001.png",
#         "long_description" => "Q1. {Geo \u2013 EG \u2013 Mineral Resources} Consider the following statements about Graphene:\n\nGraphene is completely impermeable to all gases and liquids.\nGraphene is the first two-dimensional material that human beings ever created.\nGraphene-Based Nanomaterials are used in Electronic Skin Biosensing.\nIt is almost fully transparent.\nHow many of the above statement(s) is/are correct?\n  a) Only one\n  b) Only two\n  c) Only three\n  d) All\n",
#         "correct_answer_text" => "3"
#     },
#     %{
#         "source" => "https://www.pmfias.com/ppqs-january-05-2024/",
#         "question_number" => 2,
#         "short_description" => "January 05 2024 Prelims Practice Questions (PPQs)",
#         "question_image" => "/Users/abhishek/Downloads/perps/prelims_portal/pyq_ratta/_build/dev/lib/pyq_ratta/priv/python/screenshots/January 05 2024 Prelims Practice Questions (PPQs)/quiz_002.png",
#         "long_description" => "Q2. {Ministries \u2013 Initiatives} Consider the following statements about ERNET India:\n\nIt is a not-for-profit scientific society operating under Ministry of Education.\nIt serves as the exclusive domain registrar for educational and research institutions.\nWhich of the above statement(s) is/are correct?\n  a) 1 Only\n  b) 2 Only\n  c) Both 1 and 2\n  d) Neither 1 nor 2\n",
#         "correct_answer_text" => "1"
#     },
#     %{
#         "source" => "https://www.pmfias.com/ppqs-january-05-2024/",
#         "question_number" => 3,
#         "short_description" => "January 05 2024 Prelims Practice Questions (PPQs)",
#         "question_image" => "/Users/abhishek/Downloads/perps/prelims_portal/pyq_ratta/_build/dev/lib/pyq_ratta/priv/python/screenshots/January 05 2024 Prelims Practice Questions (PPQs)/quiz_003.png",
#         "long_description" => "Q3. {Ministry \u2013 Initiatives} Consider the following statements about PRERNA scheme:\n\nUnder the scheme, Accredited Social Health Activists hold monthly meetings with the adolescent girls in their area to talk about health issues including menstrual hygiene management.\nIt is an Initiative by Ministry of Women and Child Development.\nHow many of the above statement(s) is/are correct?\n  a) 1 Only\n  b) 2 Only\n  c) Both 1 and 2\n  d) Neither 1 nor 2\n",
#         "correct_answer_text" => "3"
#     }

# ])