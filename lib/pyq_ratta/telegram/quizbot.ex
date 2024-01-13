defmodule PyqRatta.Telegram.Quizbot do
  @bot :quiz_bot

  use ExGram.Bot, name: @bot

  def init(opts) do
    ExGram.set_my_description!(description: "Welcome to ReminderBot", bot: opts[:bot])
    ExGram.set_my_name!(name: "ReminderBot", bot: opts[:bot])
    :ok
  end

  @doc """
  Assumes that every user starts with 'start' command.

  if not, implement something like read_or_insert function
  """
  def handle({:command, "start", msg}, context) do
    create_user(msg)
    |> IO.inspect(label: "created user ")

    context |> answer("Welcome to the bot! ")
  end

  def handle({:text, "start", _msg}, context) do
    create_user(msg)
    |> IO.inspect(label: "created user ")

    context |> answer("Welcome to the bot! Let's play ")
  end

  def create_user(%{chat: %{id: tg_id}} = msg) do
    Accounts.register_with_telegram(tg_id)
  end

  def create_user(_msg) do
    raise "telegram id not found in msg: #{inspect(msg)}"
  end

  # # error handling via custom error module
  # https://michal.muskala.eu/post/error-handling-in-elixir-libraries/
  # def format_error(msg) do
  # end

  # defmodule QuizbotError do
  #   defexception [:reason]
  #   alias PyqRatta.Telegram.Quizbot

  #   def exception(reason),
  #     do: %__MODULE__{reason: reason}

  #   def message(%__MODULE__{reason: reason}),
  #     do: Quizbot.format_error(reason)
  # end
end
