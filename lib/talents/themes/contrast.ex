defmodule Talents.Themes.Contrast do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "contrasts" do
    field :phrase, :string

    belongs_to :theme, Talents.Themes.Theme, foreign_key: :theme_id, primary_key: true
    belongs_to :contrast, Talents.Themes.Theme, foreign_key: :contrast_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  def changeset(contrast, attrs) do
    contrast
    |> cast(attrs, [:theme_id, :contrast_id, :phrase])
    |> validate_required([:theme_id, :contrast_id, :phrase])
  end
end
