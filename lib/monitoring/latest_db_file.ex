defmodule LatestFile do
  @moduledoc """
  # Usage
  {:ok, latest_file} = LatestFile.latest_db_file("/data/")
  """
  def latest_db_file(path) do
    File.ls!(path)
    |> Enum.filter(&String.ends_with?(&1, ".db"))
    |> Enum.map(&{&1, File.stat!("#{path}/#{&1}")})
    |> Enum.sort_by(&elem(&1, 1).mtime, :desc)
    |> List.first()
    |> case do
      nil -> {:error, "No .db files found"}
      {file, _stat} -> {:ok, file}
    end
  end
end
