defmodule Talents.Repo.Migrations.CreateOrgUsers do
  use Ecto.Migration

  def change do
    create table(:org_users) do
      add :org_id, references(:organizations, on_delete: :nothing)
      add :user_id, references(:users, type: :id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:org_users, [:user_id])
    create index(:org_users, [:org_id])
  end
end
