defmodule Talents.TalentContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talents.TalentContext` context.
  """

  @doc """
  Generate a talent.
  """
  def talent_fixture(attrs \\ %{}) do
    {:ok, talent} =
      attrs
      |> Enum.into(%{})
      |> Talents.TalentContext.create_talent()

    talent
  end
end
