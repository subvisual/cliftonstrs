defmodule Talents.Talent.Talent do
  use Ecto.Schema
  import Ecto.Changeset

  @attr [
    :name,
    :description,
    :theme,
    :i_am,
    :i_will,
    :i_love,
    :i_dislike,
    :i_bring,
    :i_need,
    :metaphor_image,
    :barrier_label
  ]

  schema "talents" do
    field :name, :string
    field :description, :string
    field :theme, :string
    field :i_am, :string
    field :i_will, :string
    field :i_love, :string
    field :i_dislike, :string
    field :i_bring, :string
    field :i_need, :string
    field :metaphor_image, :string
    field :barrier_label, :string

    has_many :contrasts, Talents.Talent.Contrast, foreign_key: :talent_id
    has_many :contrasted_with, Talents.Talent.Contrast, foreign_key: :contrast_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(talent, attrs) do
    talent
    |> cast(attrs, @attr)
    |> validate_required([:name, :description, :theme])
  end
end
