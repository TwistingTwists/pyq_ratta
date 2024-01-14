defmodule PyqRatta.Telegram.MessageFormatter do
  import ExGram.Dsl.Keyboard

  def choices_keyboard() do
    keyboard :inline do
      row do
        button("A", callback_data: "a")
        button("B", callback_data: "b")
      end

      row do
        button("C", callback_data: "c")
        button("D", callback_data: "d")
      end
    end
  end

  def welcome_message() do
    msg = """
    Welcome to the Bot \\.

    Made with Love by Team BusTicketTheory \\(BTT\\) \\.

    """
    # todo : make it easier to write markdown messages :p markdown_v2_compatible

    {msg, parse_mode: "MarkdownV2"}
  end

  def echo_msg(msg) do
    {msg, []}
  end

  # defp markdown_v2_compatible(msg) do
  #    msg
  # end
end
