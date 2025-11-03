defmodule Talents.Repo.Migrations.CreateUserTalents do
  use Ecto.Migration

  def change do
    create table(:user_talents) do
      add :position, :integer
      add :user_id, references(:users, on_delete: :delete_all)
      add :talent_id, references(:talents, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:user_talents, [:user_id])
    create index(:user_talents, [:talent_id])
  end
end
