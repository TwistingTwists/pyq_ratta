defmodule PyqRatta.Telegram.BufferedSender do
  use GenServer
  use TypedStruct
  require Logger

  import Helpers.ColorIO
  alias  PyqRatta.Telegram.Quizbot 
  @send_interval 100

  typedstruct enforce: true, visibility: :opaque, module: Message do
    @moduledoc "Message struct"
    field :chat_id, Integer.t()
    field :msg, String.t()
    field :opts, [any()]
    # field :bot, any()
  end

  typedstruct visibility: :opaque, module: Internal do
    @moduledoc "Internal state "
    field :buffer, List.t(), default: []
    # TODO  optional(ref()) type?
    field :timer, any(), default: nil
  end

  ###### Public API ######

  @doc "Start"
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def queue(chat_id, msg, tg_opts) do
    tg_opts = Keyword.merge([bot: Quizbot.bot()], tg_opts)

    msg_opts = %{chat_id: chat_id, msg: msg, opts: tg_opts}

    msg = struct(__MODULE__.Message, msg_opts )

    GenServer.cast(__MODULE__, {:queue, msg})
  end

  def send_next(user_response) do
    GenServer.cast(__MODULE__, {:send_next, user_response})
  end

  def current_state() do
    GenServer.call(__MODULE__, :get_state)
  end

  ###### Callbacks ######

  @impl GenServer
  def init(opts) do
    # Process.flag(:trap_exit, true)
    state = struct(__MODULE__.Internal, Map.new(opts))
    |> purple()
    schedule_send()
    {:ok, state}
  end

  def handle_cast({:queue, msg}, state) do
    new_buffer = state.buffer ++ [msg]

    if length(new_buffer) >= 10 do
      Logger.warning("TOO MANY messages in buffer.")
    end

    new_state = %{state | buffer: new_buffer}
    {:noreply, new_state}
  end

  def handle_info(:send_next, state) do
    state.buffer |> green("handle_info")
    state = send_now(state)
    {:noreply, state}
  end

  def schedule_send(timer \\ @send_interval) do
    Process.send_after(self(), :send_next, timer)
  end

  def send_now(%{buffer: []} = state) do
    # add additional time to reduce too many messages from itself.
    schedule_send(700)
    state
  end

  def send_now(%{buffer: [first_msg | tail]} = state) do
    # first_msg|> orange("first-msg")
    

    ExGram.send_message(first_msg.chat_id,first_msg.msg, first_msg.opts)
    |> yellow("send_message")
    schedule_send()
    %{state | buffer: tail}
  end

  # bot utilities 

  
end
