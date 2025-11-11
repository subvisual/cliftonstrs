defmodule Talents.OrgUser do
  use Ecto.Schema
  import Ecto.Changeset

  schema "org_users" do
    belongs_to :organization, Talents.Organization, foreign_key: :org_id
    belongs_to :user, Talents.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(org_user, attrs) do
    org_user
    |> cast(attrs, [])
    |> validate_required([:organization, :user])
  end
end
