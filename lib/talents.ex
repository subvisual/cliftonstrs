defmodule Talents do
  @moduledoc """
  Talents keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo
  alias Talents.{UserTalent, Talent}

  @doc """
  Returns a list of all talents with only their id and name.
  """
  def get_talents() do
    from(t in Talent, select: %{id: t.id, name: t.name})
    |> Repo.all()
    |> Enum.sort_by(fn t -> t.name end)
  end

  @doc """
  Saves a user's selected talents with positions.

  `selected_talents` is a map with rank => talent_id as strings:
  %{"1" => "17", "2" => "26"}
  """
  def save_user_talents(user_id, selected_talents) do
    Repo.transaction(fn ->
      # Delete existing user_talents for this user to proper update
      from(ut in UserTalent, where: ut.user_id == ^user_id)
      |> Repo.delete_all()

      # Insert new selections
      Enum.each(selected_talents, fn {position, talent_id} ->
        attrs = %{
          user_id: user_id,
          talent_id: String.to_integer(talent_id),
          position: String.to_integer(position)
        }

        %UserTalent{}
        |> UserTalent.changeset(attrs)
        |> Repo.insert!()
      end)
    end)
  end
end
