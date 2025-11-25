defmodule Talents.Organizations.OrgUser do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "org_users" do
    belongs_to :organization, Talents.Organizations.Organization, foreign_key: :org_id, primary_key: true
    belongs_to :user, Talents.Accounts.User, foreign_key: :user_id, primary_key: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(org_user, attrs) do
    org_user
    |> cast(attrs, [])
    |> validate_required([:organization, :user])
  end
end
