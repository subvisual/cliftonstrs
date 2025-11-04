defmodule Talents.OrgUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "org_users" do

    belongs_to :user, Talents.Organization, foreign_key: :org_id
    belongs_to :admin, Talents.Accounts.User, foreign_key: :user_id

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
