defmodule Talents.Talent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "talents" do
    field :name, :string
    field :description, :string
    field :theme, :string
    field :contrast_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(talent, attrs, user_scope) do
    talent
    |> cast(attrs, [:name, :description, :theme])
    |> validate_required([:name, :description, :theme])
    |> put_change(:user_id, user_scope.user.id)
  end
end
