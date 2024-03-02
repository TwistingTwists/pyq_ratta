defmodule PyqRatta.Telegram.MessageFormatter do
  import ExGram.Dsl.Keyboard
  alias PyqRatta.Telegram.Quizbot

  @default_opts [parse_mode: "Markdown", bot: Quizbot.bot()]
  # @default_opts [parse_mode: "MarkdownV2"]

  def choices_keyboard() do
    keyboard =
      keyboard :inline do
        row do
          button("A", callback_data: "a")
          button("B", callback_data: "b")
          button("C", callback_data: "c")
          button("D", callback_data: "d")
        end

        # row do
        #   button("C", callback_data: "c")
        #   button("D", callback_data: "d")
        # end
      end

    opts = @default_opts ++ [reply_markup: keyboard]
    {"Select Correct Choice", opts}
  end

  def welcome_message() do
    msg = """
    Welcome to the Bot \\.


    #{affiliate()}

    """

    # todo : make it easier to write markdown messages :p markdown_v2_compatible

    {msg, @default_opts}
  end

  def quiz_started(opts) do
    msg = """
    🎉︎ Quiz has started for user -  #{opts[:user]}
    quiz  - #{opts[:quiz]}

    next-question will be presented in 2s

    #{affiliate()}
    """

    {msg, @default_opts}
  end

  def quiz_ready(opts) do
    msg = """
    Link to take this quiz on telegram:

    #{opts[:link]}
    """

    {msg, @default_opts}
  end

  def echo_message(msg) do
    {msg, []}
  end

  def wrong_ans_reply(correct_answer_text) do
    msg = """
    ❌ Correct Answer is : #{correct_answer_text}
    """

    {msg, @default_opts}
  end

  def correct_ans_reply(correct_answer_text) do
    msg = """
    ✅︎ Your Answer is correct. #{correct_answer_text}
    """

    {msg, @default_opts}
  end

  def quiz_finished(link \\ nil) do
    msg = """
    🎉︎ Quiz Finished. Enjoy!

    Answers are here => #{link}

    #{affiliate()}
    """

    {msg, @default_opts}
  end

  def quiz_crashed() do
    msg = """
    ︎ Quiz Crashed for some reason. You can restart it by going to the previous link.
    """

    {msg, @default_opts}
  end

  def affiliate() do
    """
    ---
    Brought to you by SamikshaTech 🤗
    ---
    """
  end

  # defp markdown_v2_compatible(msg) do
  #    msg
  # end
end
