defmodule PyqRatta.SystemCmd do
  @moduledoc """
  see this if you want to capture some data from python side.

  https://github.com/saleyn/erlexec/
  """
  import Helpers.ColorIO

  def parse_url(url) do
    reply = {parent, ref} = {self(), make_ref()}

    task =
      Task.Supervisor.async_nolink(PyqRatta.Telegram.TaskSupervisor, fn ->
        take_screenshot_cmd(url)

        # receive do
        #   val -> yellow("received value from task: #{inspect(val)}")
        # end
      end)
      |> green("#{__MODULE__}")
  end

  def take_screenshot_cmd(url) do
    MuonTrap.cmd(
      "python3",
      [get_quiz_path(), "--url", url, "--output_folder", screenshot_folder()],
      into: IO.stream(:stdio, :line)
    )
  end

  defp get_quiz_path() do
    :code.priv_dir(:pyq_ratta)
    |> Path.join("python/get_quiz.py")
  end

  defp screenshot_folder() do
    :code.priv_dir(:pyq_ratta)
    |> Path.join("python/screenshots")
    |> purple("screnshot folder")
  end
end
