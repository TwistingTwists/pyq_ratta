defmodule Telegram.Middlewares.RegisterUser do
  use ExGram.Middleware
  alias ExGram.Cnt
  alias PyqRatta.Accounts.User
  require Logger
  import ExGram.Dsl

  def call(%Cnt{update: update} = cnt, _opts) do
    with {:ok, %{id: telegram_id} = user} <- extract_user(update) do
      maybe_register_user(telegram_id, user)
    else
      error_val ->
        Logger.error(
          "Could not extract_user with tg_id : #{inspect(update)} with error: #{inspect(error_val)}"
        )
    end

    cnt
  end

  def call(cnt, _), do: cnt

  def maybe_register_user(tg_id, user) when not is_nil(tg_id) do
    case User.get_by(%{telegram_id: tg_id}) do
      {:ok, %User{id: _id}} = user ->
        Logger.debug("User Already exists : #{inspect(user.id)}")
        user

      anything_else ->
        Logger.debug("Registering User with : #{inspect(anything_else)}")
        User.register_with_telegram(tg_id)
    end
  end
end
