# defmodule Telegram.Bot do
#   @moduledoc """
#   The Telegram Bot.
#   """

#   @type t :: %__MODULE__{
#           bot_id: String.t(),
#           bot_module: module()
#         }

#   @enforce_keys [:bot_id, :bot_module]
#   defstruct [:bot_id, :bot_module]

#   @doc """
#   Handle the event from Telegram.
#   Return value is ignored.
#   """
#   @callback handle_event(type :: String.t(), payload :: map()) :: any()

#   defmacro __using__(opts) do
#     # just to ensure :name is passed
#     _bot_name = Keyword.fetch!(opts, :name)

#     quote bind_quoted: [opts: opts] do
#       import Telegram.Bot
#       @behaviour Telegram.Bot
#       use ExGram.Bot, name: opts[:name]
#     end
#   end

#   # Build a Bot struct from a string-keyed map.
#   @doc false
#   # def from_string_params(bot_module, params) do
#   #   %__MODULE__{
#   #     bot_id: Map.fetch!(params, "bot_id"),
#   #     bot_module: bot_module
#   #   }
#   # end

#   @doc """
#   Send a message to a channel.

#   The `message` can be just the message text, or a `t:map/0` of properties that
#   are accepted by Telegram's `chat.postMessage` API endpoint.
#   """
#   @spec send_message(String.t(), String.t() | map()) :: Macro.t()
#   defmacro send_message(channel, message) do
#     quote do
#       Telegram.MessageServer.send(__MODULE__, unquote(channel), unquote(message))
#     end
#   end
# end
