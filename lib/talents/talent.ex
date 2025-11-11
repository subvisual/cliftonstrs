defmodule Talents.Talent do
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
    :barrier_label,
    :text_contrast_one,
    :text_contrast_two
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
    field :text_contrast_one, :string
    field :text_contrast_two, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(talent, attrs) do
    talent
    |> cast(attrs, @attr)
    |> validate_required([:name, :description, :theme])
  end
end
