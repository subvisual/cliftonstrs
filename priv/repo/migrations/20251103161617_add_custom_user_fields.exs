defmodule Talents.Repo.Migrations.AddCustomUserFields do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string, null: false
      add :avatar, :string
    end
  end
end
