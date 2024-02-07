defmodule PyqRatta.Accounts.Preparations.CheckCache do
  @moduledoc """
    Checks cachex for simple user
  """
  def users_cache, do: :users_cache

  use Ash.Resource.Preparation
  alias PyqRatta.Accounts.User
  import Helpers.ColorIO

  def prepare(query, opts, _) when query.arguments.check_cache == true do
    user_tg_id =
      opts[:arg]
      |> yellow("user_tg_id")

    # user_tg_id = Ash.Changeset.get_argument(user_tg_id_arg)
    Ash.Query.before_action(query, fn query ->
      # todo unimplemented - check via cachex for user id
      # quote do unquote(query.filter) end |> purple("Query filetr")
      case Cachex.get(users_cache(), cache_key(user_tg_id)) do
        {:ok, nil} ->
          {:ok, user} = User.by_tgid(user_tg_id, %{check_cache: false})
          |> cache_now()
          yellow("#{user.telegram_id}  -- from db")
          Ash.Query.set_result(query, {:ok, [user]})
          # {:ok, user}

        {:ok, user} ->
          yellow("#{user.telegram_id}  -- from cache")
          Ash.Query.set_result(query, {:ok, [user]})
      end
    end)
  end

  def prepare(query, _, _) do
    query
    |> blue("entered cache_false query ")
  end

  defp cache_now({:ok, user}) do
    Cachex.put(users_cache(), cache_key(user.telegram_id) , user)
    {:ok, user}
  end

  defp cache_key(user_tg_id) do
    "#{user_tg_id}_user"
  end
end
