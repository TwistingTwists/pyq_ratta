defmodule PyqRatta.SystemCmd do
  import Helpers.ColorIO

  def parse_url(url) do
    spawn(fn ->
      MuonTrap.cmd(
        "python3",
        [get_quiz_path(), "--url", url, "--output_folder", screenshot_folder()],
        into: IO.stream(:stdio, :line)
      )
    end)
    |> green("#{__MODULE__}")
  end

  defp get_quiz_path() do
    :code.priv_dir(:pyq_ratta)
    |> Path.join( "python/get_quiz.py" )

  end

  defp screenshot_folder() do
    :code.priv_dir(:pyq_ratta)
    |> Path.join( "python/screenshots" )
    |> purple("screnshot folder")
  end
end
