defmodule PyqRatta.ReadConfig do
  def tg_bot() do
    %{name: System.get_env("QUIZ_BOT_NAME") || "quizdrill_staging_bot"}
  end
end
