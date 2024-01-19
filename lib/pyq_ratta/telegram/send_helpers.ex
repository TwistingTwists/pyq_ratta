defmodule PyqRatta.Telegram.SendHelpers do
    @message_types [{:mp4, ~r/.mp4$/ }, {:img, ~r/.[jpeg|jpg|png]$/}, {:doc, ~r/.[pdf|txt|sh]$/}]

    @doc """
    filename = "./files/filename.mp4"
    """
    def send(filename, chat_id, bot, tg_msg_opts \\ []) do
      filename |> parse |> do_reply(chat_id, bot,tg_msg_opts)
      # broadcast!(%{message: "file_sent", type: :ok , reason: "sucess"})
    end

    defp parse(msg) do
      {type, _regex} =
        Enum.find(@message_types, {:doc,nil}, fn {  _type,reg} ->
          String.match?(msg, reg)
        end)

      {type, msg}
    end

    defp do_reply({:mp4, file},  chat_id, bot,tg_msg_opts)
      do
        opts = tg_msg_opts ++ [bot: bot, caption: file |> get_name,
        supports_streaming: true]
        ExGram.send_video(chat_id, {:file, file},opts)

      end

    defp do_reply({:img, file},  chat_id, bot,tg_msg_opts)
      do
        opts = tg_msg_opts ++ [bot: bot]
        ExGram.send_photo(chat_id, {:file, file}, opts)
      end

    defp do_reply({:doc, file},  chat_id, bot),
      do: ExGram.send_document(chat_id, {:file, file}, bot: bot)

    defp do_reply({:doc, nil},  _chat_id, _bot),
      do: IO.inspect("got nil filename, so not sending anything")

    def get_name(file), do: String.split(file, "/") |> List.last("Video File by putdownbot")
    # def broadcast!(data), do: Phoenix.PubSub.broadcast(:my_pubsub,   "send_file", data)

end
