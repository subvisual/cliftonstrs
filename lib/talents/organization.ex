defmodule Talents.Organization do
  use Ecto.Schema
  import Ecto.Changeset

  schema "organizations" do
    field :name, :string
    field :avatar, :string

    belongs_to :admin, Talents.Accounts.User, foreign_key: :admin_id
    many_to_many :users, Talents.Accounts.User, join_through: "org_users"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(organization, attrs) do
    organization
    |> cast(attrs, [:name, :avatar])
    |> validate_required([:name, :avatar])
  end
end
