defmodule Talents.UserTalent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_talents" do
    field :position, :integer
    field :user_id, :id
    field :talent_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_talent, attrs, user_scope) do
    user_talent
    |> cast(attrs, [:position])
    |> validate_required([:position])
    |> put_change(:user_id, user_scope.user.id)
  end
end
