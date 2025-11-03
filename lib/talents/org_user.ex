defmodule Talents.OrgUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "org_users" do

    field :org_id, :id
    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(org_user, attrs, user_scope) do
    org_user
    |> cast(attrs, [])
    |> validate_required([])
    |> put_change(:user_id, user_scope.user.id)
  end
end
