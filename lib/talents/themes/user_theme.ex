defmodule Talents.Themes.UserTheme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "user_themes" do
    field :position, :integer

    belongs_to :theme, Talents.Themes.Theme, foreign_key: :theme_id, primary_key: true
    belongs_to :user, Talents.Accounts.User, foreign_key: :user_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_theme, attrs) do
    user_theme
    |> cast(attrs, [:position, :theme_id, :user_id])
    |> validate_required([:position, :theme_id, :user_id])
  end
end
