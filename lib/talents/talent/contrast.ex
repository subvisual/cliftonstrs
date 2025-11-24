defmodule Talents.Talent.Contrast do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "contrasts" do
    field :phrase, :string

    belongs_to :talent, Talents.Talent.Talent, foreign_key: :talent_id, primary_key: true
    belongs_to :contrast, Talents.Talent.Talent, foreign_key: :contrast_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  def changeset(contrast, attrs) do
    contrast
    |> cast(attrs, [:talent_id, :contrast_id, :phrase])
    |> validate_required([:talent_id, :contrast_id, :phrase])
  end
end
