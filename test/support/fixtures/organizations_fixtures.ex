defmodule Talents.OrganizationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talents.Organizations` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{})
      |> Talents.Organizations.create_organization()

    organization
  end
end
