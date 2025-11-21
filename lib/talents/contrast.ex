defmodule Talents.Contrast do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contrasts" do
    field :phrase, :string

    belongs_to :talent, Talents.Talent
    belongs_to :contrast, Talents.Talent

    timestamps(type: :utc_datetime)
  end

  def changeset(contrast, attrs) do
    contrast
    |> cast(attrs, [:talent_id, :contrast_id, :phrase])
    |> validate_required([:talent_id, :contrast_id, :phrase])
  end
end
