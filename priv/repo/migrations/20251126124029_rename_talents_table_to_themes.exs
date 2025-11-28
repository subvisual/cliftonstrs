defmodule Talents.Repo.Migrations.RenameTalentsTableToThemes do
  use Ecto.Migration

  def change do
    # Tables
    rename table("talents"), to: table("themes")
    rename table("user_talents"), to: table("user_themes")

    # Columns
    rename table("user_themes"), :talent_id, to: :theme_id
    rename table("contrasts"), :talent_id, to: :theme_id
    rename table("themes"), :theme, to: :domain
  end
end
