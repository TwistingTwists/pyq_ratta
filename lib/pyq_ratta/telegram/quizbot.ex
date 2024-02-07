defmodule PyqRatta.Telegram.Quizbot do
  @bot :quiz_bot

  alias PyqRatta.Accounts
  alias PyqRatta.Telegram.Commands
  alias PyqRatta.Telegram.MessageFormatter, as: MF
  alias PyqRatta.Workers.UserAttemptServer, as: UAS
  alias PyqRatta.Telegram.ChannelCommands.NewPost
  alias __MODULE__

  use ExGram.Bot, name: @bot

  require MyInspect
  import Helpers.ColorIO

  middleware(Telegram.Middlewares.RegisterUser)

  def bot(), do: @bot

  def init(opts) do
    ExGram.set_my_description!(description: "Welcome to ReminderBot", bot: opts[:bot])
    # ExGram.set_my_name!(name: "ReminderBot", bot: opts[:bot])
    :ok
  end

  ######## start ########
  @doc """
  Assumes that every user starts with 'start' command.

  if not, implement something like read_or_insert function
  """
  def handle({:command, "start", %{text: quiz_id} = msg}, context) do
    quiz_id |> MyInspect.print()

    {edited_msg, opts} = msg |> do_handle(:start_quiz, quiz_id)
    answer(context, edited_msg, opts)
  end

  def do_handle(_msg, :start_quiz, quiz_id) when quiz_id in ["", nil] do
    MF.welcome_message()
  end

  def do_handle(msg, :start_quiz, quiz_id) do
    user_id = msg.chat.id
    quiz_id |> MyInspect.print()

    Commands.start_quiz(user_id, quiz_id)
  end

  def handle({:text, _any, msg}, context) do
    {msg, opts} = MF.welcome_message()
    answer(context, msg, opts)
  end

  # when link is posted in the channel
  def handle(
        {:update,
         %ExGram.Model.Update{
           channel_post: %{link_preview_options: url, chat: %{id: channel_id, type: "channel"}}
         }},
        context
      ) do
    NewPost.process_link(url)
    |> NewPost.maybe_send_reply(channel_id)
  end

  ######## any other command ########

  def handle({:command, _any, msg}, context) do
    answer(context, "This is not supported at the moment.")
  end

  ######## quizlist ########
  def handle({:command, "quizlist", msg}, context) do
    {msg, opts} = MF.welcome_message()
    answer(context, msg, opts)
  end

  ######## reply to quiz question ########

  def handle(
        {:callback_query,
         %{
           chat_instance: chat_instance,
           data: data,
           from: from,
           id: msg_id_maybe,
           message: %{message_id: message_id}
         } = msg},
        context
      ) do
    response = "your ans: #{data}"
    opts = []
    Process.sleep(1000)
    UAS.next(from.id, data)

    chat_id = msg.message.chat.id

    ExGram.edit_message_reply_markup(
      chat_id: chat_id,
      message_id: message_id,
      reply_markup: %ExGram.Model.InlineKeyboardMarkup{},
      bot: bot()
    )

    # |> MyInspect.print()
  end

  ######## echo message ########

  def handle({:text, anything_else, msg}, context) do
    {msg, opts} = MF.echo_message(msg)

    answer(context, msg, opts)
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
