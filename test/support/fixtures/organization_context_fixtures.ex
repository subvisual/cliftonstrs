defmodule Talents.OrganizationContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talents.OrganizationContext` context.
  """

  @doc """
  Generate a organization.
  """
  def organization_fixture(attrs \\ %{}) do
    {:ok, organization} =
      attrs
      |> Enum.into(%{})
      |> Talents.OrganizationContext.create_organization()

    organization
  end
end
