defmodule PyqRatta.Telegram.MessageFormatter do
  import ExGram.Dsl.Keyboard

  @default_opts [parse_mode: "Markdown"]
  # @default_opts [parse_mode: "MarkdownV2"]

  def choices_keyboard() do
   keyboard =  keyboard :inline do
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
   {"Select Correct Choice",  opts}

  end

  def welcome_message() do
    msg = """
    Welcome to the Bot \\.

    Made with Love by Team BusTicketTheory \\(BTT\\) \\.

    """

    # todo : make it easier to write markdown messages :p markdown_v2_compatible

    {msg, @default_opts}
  end

  def quiz_started(opts) do

    msg = """
    Quiz has started for user -  #{opts[:user]}
    quiz  - #{opts[:quiz]}
    """
    {msg, @default_opts}
  end

  def echo_message(msg) do
    {msg, []}
  end

  # defp markdown_v2_compatible(msg) do
  #    msg
  # end
end
