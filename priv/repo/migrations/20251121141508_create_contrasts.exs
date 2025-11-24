defmodule Talents.Repo.Migrations.CreateContrasts do
  use Ecto.Migration

  def change do
    create table(:contrasts, primary_key: false) do
      add :talent_id, references(:talents, on_delete: :delete_all), null: false
      add :contrast_id, references(:talents, on_delete: :delete_all), null: false
      add :phrase, :string

      timestamps(type: :utc_datetime)
    end

    create index(:contrasts, [:talent_id])
    create index(:contrasts, [:contrast_id])

    # To avoid duplicates
    create unique_index(:contrasts, [:talent_id, :contrast_id])
  end
end
