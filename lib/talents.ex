defmodule Talents do
  @moduledoc """
  Talents keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query, warn: false
  alias Talents.Accounts.User
  alias Talents.Repo
  alias Talents.{UserTalent, Talent, OrgUser, Organization}

  @doc """
  Returns a list of all talents with only their id and name.
  """
  def get_talents() do
    from(t in Talent, select: %{id: t.id, name: t.name, theme: t.theme})
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
      order_by: [asc: o.name],
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
  Get the information of an organization with members ordered: admin first, then alphabetically.
  """
  def get_organization_info(org_id) do
    org = Repo.get!(Organization, org_id)

    users_query =
      from u in User,
        join: ou in OrgUser,
        on: ou.user_id == u.id,
        where: ou.org_id == ^org.id,
        order_by: [
          desc: fragment("? = ?", u.id, ^org.admin_id),
          asc: u.name
        ],
        select: u

    Repo.preload(org, [:admin, users: users_query])
  end

  @doc """
  Removes a user from an organization.

  Returns `{count, _}` where:
    * `{1, _}` — the user was removed (row deleted)
    * `{0, _}` — the user was not a member (no row deleted)
  """
  def remove_member(org_id, user_id) do
    from(ou in OrgUser, where: ou.org_id == ^org_id and ou.user_id == ^user_id)
    |> Repo.delete_all()
  end

  @doc """
  Changes the organization admin, but only if the new admin is already a member.

  Returns `{count, _}` where:
    * `{1, _}` — admin updated successfully
    * `{0, _}` — update blocked because the user is not a member
  """
  def update_admin(org_id, new_admin_id) do
    from(o in Organization,
      where: o.id == ^org_id,
      join: ou in OrgUser,
      on: ou.org_id == o.id and ou.user_id == ^new_admin_id
    )
    |> Repo.update_all(set: [admin_id: new_admin_id])
  end

  @doc """
  Delete an organization.
  """
  def delete_organization(org) do
    Repo.transact(fn ->
      from(ou in OrgUser, where: ou.org_id == ^org.id)
      |> Repo.delete_all()

      Repo.delete(org)
    end)
  end

  @doc """
  Update an organizaton.
  """
  def update_organization(org, attrs) do
    org
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns the user top 10 talents.
  """
  def get_user_top_talents(user_id) do
    from(ut in UserTalent,
      join: t in Talent,
      on: ut.talent_id == t.id,
      where: ut.user_id == ^user_id and ut.position <= 10,
      order_by: ut.position,
      select: t
    )
    |> Repo.all()
  end

  @doc """
  Makes the theme distribution of a given list of users.
  """
  def theme_distribution(user_list) do
    talent_map =
      Talents.get_talents()
      |> Map.new(fn t -> {{t.name, t.theme}, 0} end)

    user_list
    |> Enum.flat_map(fn u -> Talents.get_user_top_talents(u.id) end)
    |> Enum.reduce(
      talent_map,
      fn t, acc -> Map.update(acc, {t.name, t.theme}, 1, fn current -> current + 1 end) end
    )
    |> Enum.sort_by(fn {_k, v} -> v end, :desc)
  end
end
