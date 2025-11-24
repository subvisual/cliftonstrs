defmodule Talents.Repo.Migrations.AlterUserTalentTable do
  use Ecto.Migration

  def change do
    create unique_index(:user_talents, [:talent_id, :user_id])

    alter table(:user_talents) do
      remove :id
    end
  end
end
