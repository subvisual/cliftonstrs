defmodule Talents do
  @moduledoc """
  Talents keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo
  alias Talents.{UserTalent, Talent, OrgUser, Organization}

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

  @doc """
  Returns a map of a user's selected talents with their positions.
  """
  def get_user_positions(user_id) do
    from(ut in UserTalent, where: ut.user_id == ^user_id)
    |> Repo.all()
    |> Map.new(fn ut -> {Integer.to_string(ut.position), Integer.to_string(ut.talent_id)} end)
  end

  @doc """
  Returns a list of organizatons that a user is member.
  """
  def get_user_organizations(user_id) do
    from(o in Organization,
      join: ou in OrgUser,
      on: ou.org_id == o.id,
      where: ou.user_id == ^user_id,
      preload: [:admin, :users]
    )
    |> Repo.all()
  end

  @doc """
  Create a new organizaton.
  """
  def create_organization(attrs) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Get the information of a organizaton.
  """
  def get_organization_info(org_id) do
    Organization
    |> Repo.get!(org_id)
    |> Repo.preload([:admin, :users])
  end

  @doc """
  Remove a member from a organizaton.
  """
  def remove_member(org_id, user_id) do
    from(ou in OrgUser,
      where: ou.org_id == ^org_id and ou.user_id == ^user_id
    )
    |> Repo.delete_all()
  end
end
