defmodule Talents.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :avatar, :string
    field :admin_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs, user_scope) do
    organization
    |> cast(attrs, [:name, :avatar])
    |> validate_required([:name, :avatar])
    |> put_change(:user_id, user_scope.user.id)
  end
end
