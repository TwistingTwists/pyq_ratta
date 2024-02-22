defmodule PyqRatta.Telegram.Commands do
  @moduledoc """
  This is glue module between telegram low level api and running a quiz.

  This module is responsible for starting / stopping UserAttemptServer.

  This also manages interface to/from quizbot.
  """

  use Supervisor

  alias PyqRatta.Telegram.Quizbot
  alias PyqRatta.Telegram.SendHelpers
  alias PyqRatta.Telegram.MessageFormatter, as: MF

  require MyInspect
  require Logger
  @registry __MODULE__.Registry
  @supervisor __MODULE__
  @dynamic_supervisor __MODULE__.DynamicSupervisor
  @task PyqRatta.Workers.UserAttemptServer

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, {}, name: __MODULE__)
  end

  @impl true
  def init({}) do
    children =
      [
        {Registry, name: @registry, keys: :unique},
        {DynamicSupervisor, name: @dynamic_supervisor, strategy: :one_for_one},
        PyqRatta.Telegram.QuizChecker
      ]
      |> MyInspect.print()

    Supervisor.init(children, strategy: :one_for_all)
  end

  ###### interface with ExGram low level API ######

  @doc """
  key for finding the UserAttemptServer: user_id
  > A user has only one instance of UserAttemptServer running at the moment.

  """
  def start_quiz(user_id, quiz_id) do
    pid =
      case Registry.lookup(@registry, user_id) do
        [{pid, _}] ->
          pid

        [] ->
          # child_spec = %{id: user_id, start: {@task, :start_link, [user_tg_id: user_id, quiz_id: quiz_id]}, type: :worker}
          args = [user_tg_id: user_id, quiz_id: quiz_id]

          case DynamicSupervisor.start_child(@dynamic_supervisor, {@task, args}) do
            {:ok, pid} ->
              pid

            {:error, {:already_started, pid}} ->
              pid

            unknown ->
              Logger.error("unknown return by DynamicSupervisor.start_child
              #{inspect(unknown)}")
              nil
          end
      end

    # ref = Process.monitor(pid)

    MF.quiz_started(user: user_id, quiz: quiz_id)
  end

  def via(user_id) do
    {:via, Registry, {@registry, user_id}}
  end

  ###### interface with user / db ######

  def send_to_tg(user_id, question) do
    do_send_question(user_id, question)
  end

  def do_send_question(user_tg_id, %{question_image: q_img} = _question) do
    {img_caption, opts} = MF.choices_keyboard()
    tg_msg_opts = opts ++ [caption: img_caption]

    {:ok, returned_msg} = SendHelpers.send(q_img, user_tg_id, Quizbot.bot(), tg_msg_opts)
  end

  def send_quiz_ready(quiz) do
    # https://t.me/quizdrill_staging_bot?start=55e8278b-3646-42e4-8ccf-1374d42f2607
    %{name: quiz_bot_name} = PyqRatta.ReadConfig.tg_bot()
    query_params = URI.encode_query(%{start: quiz.id})

    link =
      "https://t.me/#{quiz_bot_name}"
      |> URI.parse()
      |> URI.append_query(query_params)
      |> URI.to_string()

    {msg, opts} = MF.quiz_ready(link: link)

    import Helpers.ColorIO

    params = struct(ExGram.Model.ReplyParameters, message_id: msg_id())

    opts =
      opts
      |> Keyword.put(:parse_mode, "HTML")
      |> Keyword.put_new(:bot, Quizbot.bot())
      |> Keyword.put_new(:reply_parameters, params)
      |> yellow("opts")

    ExGram.send_message(channel_id(), msg, opts)
    |> purple("send message")
  end

  def channel_id do
    # todo save
    -1_002_007_415_732
  end

  def msg_id, do: 48
end
