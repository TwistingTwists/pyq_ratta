defmodule PyqRatta.QuizTest do
  use PyqRatta.DataCase, async: false

  alias PyqRatta.Databank.Quiz
  alias PyqRatta.Databank.Question
  alias PyqRatta.Databank.QuizQuestion
  alias PyqRatta.Accounts

  describe "creating users:" do
    test "create user with given telegram_id" do
      tg_id = Factory.telegram_ids() |> hd()

      assert {:ok, user} =
               Accounts.User.register_with_telegram(tg_id)
               |> IO.inspect(label: "registered with tg")
    end
  end
end
