defmodule LiveNotify do
  alias PyqRatta.Telegram.BufferedSender, as: TgSender
  alias PyqRatta.Telegram.Quizbot

  def count, do: DynamicSupervisor.count_children(PyqRatta.Telegram.Commands.DynamicSupervisor)

  def notify do
    user_pids =
      DynamicSupervisor.which_children(PyqRatta.Telegram.Commands.DynamicSupervisor)
      |> Enum.map(fn {:undefined, pid, _, _} -> pid end)

    msg = """
    🤔 Did you get distracted while taking the quiz? Don't worry. 🚀
    You can resume it now. 👍

    Just attempt the question above. 👆👆
    """

    alias PyqRatta.Telegram.Quizbot
    opts = [parse_mode: "Markdown", bot: Quizbot.bot()]

    Enum.map(user_pids, fn user_pid ->
      {_, _, _, [_, _, _, _, genserver_state]} = :sys.get_status(user_pid)

      [_first, [{_, internal_state}]] = Keyword.get_values(genserver_state, :data)

      TgSender.queue(internal_state.user_tg_id, msg, opts)

      {internal_state.user.telegram_id, internal_state.previous_question.question_image}
    end)
  end
end
