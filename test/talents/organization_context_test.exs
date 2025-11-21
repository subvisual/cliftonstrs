defmodule Talents.OrganizationContextTest do
  use Talents.DataCase

  alias Talents.OrganizationContext

  describe "organizations" do
    alias Talents.OrganizationContext.Organization

    import Talents.OrganizationContextFixtures

    @invalid_attrs %{}

    test "list_organizations/0 returns all organizations" do
      organization = organization_fixture()
      assert OrganizationContext.list_organizations() == [organization]
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = organization_fixture()
      assert OrganizationContext.get_organization!(organization.id) == organization
    end

    test "create_organization/1 with valid data creates a organization" do
      valid_attrs = %{}

      assert {:ok, %Organization{} = organization} =
               OrganizationContext.create_organization(valid_attrs)
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = OrganizationContext.create_organization(@invalid_attrs)
    end

    test "update_organization/2 with valid data updates the organization" do
      organization = organization_fixture()
      update_attrs = %{}

      assert {:ok, %Organization{} = organization} =
               OrganizationContext.update_organization(organization, update_attrs)
    end

    test "update_organization/2 with invalid data returns error changeset" do
      organization = organization_fixture()

      assert {:error, %Ecto.Changeset{}} =
               OrganizationContext.update_organization(organization, @invalid_attrs)

      assert organization == OrganizationContext.get_organization!(organization.id)
    end

    test "delete_organization/1 deletes the organization" do
      organization = organization_fixture()
      assert {:ok, %Organization{}} = OrganizationContext.delete_organization(organization)

      assert_raise Ecto.NoResultsError, fn ->
        OrganizationContext.get_organization!(organization.id)
      end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = organization_fixture()
      assert %Ecto.Changeset{} = OrganizationContext.change_organization(organization)
    end
  end
end
