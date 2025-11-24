defmodule Talents.Repo.Migrations.AlterOrgUserTable do
  use Ecto.Migration

  def change do
    create unique_index(:org_users, [:org_id, :user_id])

    alter table(:org_users) do
      remove :id
    end
  end
end
