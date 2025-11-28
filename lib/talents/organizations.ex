defmodule Talents.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo
  alias Talents.Accounts.User
  alias Talents.Organizations.{Organization,OrgUser}

  @doc """
  Returns the list of organizations.

  ## Examples

      iex> list_organizations()
      [%Organization{}, ...]

  """
  def list_organizations do
    from(o in Organization, select: %{id: o.id, name: o.name})
    |> Repo.all()
    |> Enum.sort_by(fn t -> t.name end)
  end

  @doc """
  Gets a single organization.

  Raises if the Organization does not exist.

  ## Examples

      iex> get_organization!(123)
      %Organization{}

  """
  def get_organization!(id), do: Repo.get!(Organization, id)

  @doc """
  Creates a organization.

  ## Examples

      iex> create_organization(%{field: value})
      {:ok, %Organization{}}

      iex> create_organization(%{field: bad_value})
      {:error, ...}

  """
  def create_organization(attrs) do
    %Organization{}
    |> Organization.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a organization.

  ## Examples

      iex> update_organization(organization, %{field: new_value})
      {:ok, %Organization{}}

      iex> update_organization(organization, %{field: bad_value})
      {:error, ...}

  """
  def update_organization(%Organization{} = organization, attrs) do
    organization
    |> Organization.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Organization.

  ## Examples

      iex> delete_organization(organization)
      {:ok, %Organization{}}

      iex> delete_organization(organization)
      {:error, ...}

  """
  def delete_organization(org) do
    Repo.transact(fn ->
      from(ou in OrgUser, where: ou.org_id == ^org.id)
      |> Repo.delete_all()

      Repo.delete(org)
    end)
  end

  @doc """
  Returns a data structure for tracking organization changes.

  ## Examples

      iex> change_organization(organization)
      %Todo{...}

  """
  def change_organization(%Organization{} = organization, attrs \\ %{}) do
    Organization.changeset(organization, attrs)
  end

  @doc """
  Returns a list of organizatons that a user is member.
  """
  def list_user_organizations(user_id) do
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
  Get the information of an organization with members ordered: admin first, then alphabetically.
  """
  def get_organization_info(org_id) do
    org = get_organization!(org_id)

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
  Adds an user to the organization.
  """
  def add_member_to_org(user_id, org_id) do
    %OrgUser{}
    |> OrgUser.changeset(%{org_id: org_id, user_id: user_id})
    |> Repo.insert!()
  end
end
