defmodule Talents.ThemesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Talents.Themes` context.
  """

  @doc """
  Generate a theme.
  """
  def theme_fixture(attrs \\ %{}) do
    {:ok, theme} =
      attrs
      |> Enum.into(%{})
      |> Talents.Themes.create_theme()

    theme
  end
end
