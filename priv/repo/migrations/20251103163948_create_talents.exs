defmodule Talents.Repo.Migrations.CreateTalents do
  use Ecto.Migration

  def change do
    create table(:talents) do
      add :name, :string
      add :description, :text
      add :theme, :string
      add :contrast_id, references(:talents, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:talents, [:contrast_id])
  end
end
