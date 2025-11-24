defmodule Talents.Repo.Migrations.RemoveTextContrats do
  use Ecto.Migration

  def change do
    alter table(:talents) do
      remove :text_contrast_one
      remove :text_contrast_two
    end
  end
end
