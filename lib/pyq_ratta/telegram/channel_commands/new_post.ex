defmodule PyqRatta.Telegram.ChannelCommands.NewPost do
  import Helpers.ColorIO
  alias PyqRatta.Telegram.MessageFormatter, as: MF
  alias PyqRatta.Telegram.Quizbot

  def process_link(nil) do
    # ignore
    :ignore
  end

  def process_link(%{url: url}) do
    case URI.parse(url) do
      %URI{
        path: path,
        host: "www.pmfias.com"
      }
      when not is_nil(path) ->
        do_process(url)
        :processed

      invalid_url ->
        red("not processing url: #{invalid_url}")
        :ignore
    end
  end

  def do_process(url) do
    if String.contains?(url, "ppqs") do
      url |> green("processing: #{__MODULE__}")
      PyqRatta.SystemCmd.parse_url(url)
      # |> create quiz
      # get the telegram link
      # post in the channel
    end
  end

  def maybe_send_reply(:processed, chat_id) do
    {msg, opts} = {"now processing the files", [bot: Quizbot.bot()]}
    opts = Keyword.put_new(opts, :bot, Quizbot.bot())
    ExGram.send_message(chat_id, msg, opts)
  end

  def maybe_send_reply(:ignore, _chat_id) do
    # do nothing
  end
end
