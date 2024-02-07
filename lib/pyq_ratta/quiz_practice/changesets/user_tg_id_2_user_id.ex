defmodule PyqRatta.QuizPractice.Changesets.UserTgIdtoUserId do
  use Ash.Resource.Change
  alias PyqRatta.Accounts.User
  import Helpers.ColorIO

  def change(changeset, opts, _) do
    user_tg_id = opts[:arg]
    user_id = opts[:attr]

    opts |> purple("opts ")
    changeset |> orange("cs ")

    user_tg_id_val =
      Ash.Changeset.get_argument(changeset, user_tg_id)
      |> green(" user_tg_id ")

    user = User.by_tgid!(user_tg_id_val)

    Ash.Changeset.change_attribute(changeset, user_id, user.id)
  end
end
