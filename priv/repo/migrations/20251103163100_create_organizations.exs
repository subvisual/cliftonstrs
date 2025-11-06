defmodule Talents.Repo.Migrations.CreateOrganizations do
  use Ecto.Migration

  def change do
    create table(:organizations) do
      add :name, :string
      add :avatar, :string
      add :admin_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:organizations, [:admin_id])
  end
end
