defmodule PyqRatta.Repo.Migrations.QuestionImageTg do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:question) do
      add :question_image_tg, :text
    end
  end

  def down do
    alter table(:question) do
      remove :question_image_tg
    end
  end
end