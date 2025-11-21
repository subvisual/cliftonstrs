defmodule Talents.Talent.UserTalent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_talents" do
    field :position, :integer

    belongs_to :talent, Talents.Talent.Talent, foreign_key: :talent_id
    belongs_to :user, Talents.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_talent, attrs) do
    user_talent
    |> cast(attrs, [:position, :talent_id, :user_id])
    |> validate_required([:position, :talent_id, :user_id])
  end
end
