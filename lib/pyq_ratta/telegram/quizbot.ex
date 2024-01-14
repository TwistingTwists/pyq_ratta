defmodule PyqRatta.Telegram.Quizbot do
  @bot :quiz_bot

  alias PyqRatta.Accounts
  alias PyqRatta.Telegram.MessageFormatter, as: MF

  use ExGram.Bot, name: @bot

  middleware(Telegram.Middlewares.RegisterUser)

  def bot(), do: @bot

  def init(opts) do
    ExGram.set_my_description!(description: "Welcome to ReminderBot", bot: opts[:bot])
    # ExGram.set_my_name!(name: "ReminderBot", bot: opts[:bot])
    :ok
  end

  @doc """
  Assumes that every user starts with 'start' command.

  if not, implement something like read_or_insert function
  """
  def handle({:command, "start", msg}, context) do
    # create_user(msg)
    # |> IO.inspect(label: "created user ")

    {msg, opts} = MF.welcome_message()
    answer(context, msg, opts)
  end

  def handle({:command, "quizlist", msg}, context) do
    {msg, opts} = MF.welcome_message()
    answer(context, msg, opts)
  end

  def handle({:text, "start", msg}, context) do
    # create_user(msg)
    # |> IO.inspect(label: "created user ")

    {msg, opts} = MF.welcome_message()
    answer(context, msg, opts)
  end

  def handle({:text, anything_else, msg}, context) do
    {msg, opts} = MF.echo_message(msg)

    answer(context, msg, opts)
  end

  # def create_user(%{chat: %{id: tg_id}} = msg) do
  #   Accounts.User.register_with_telegram(tg_id)
  # end

  # def create_user(msg) do
  #   raise "telegram id not found in msg: #{inspect(msg)}"
  # end

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
