defmodule Talents.Themes do
  @moduledoc """
  The Themes context.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo

  alias Talents.Themes.{UserTheme, Theme, Contrast}

  @doc """
  Returns the list of themes.

  ## Examples

      iex> list_themes()
      [%Theme{}, ...]

  """
  def list_themes do
    from(t in Theme, select: %{id: t.id, name: t.name})
    |> Repo.all()
    |> Enum.sort_by(fn t -> t.name end)
  end

  @doc """
  Gets a single theme.

  Raises if the Theme does not exist.

  ## Examples

      iex> get_theme!(123)
      %Theme{}

  """
  def get_theme!(id), do: Repo.get!(Theme, id)

  @doc """
  Creates a theme.

  ## Examples

      iex> create_theme(%{field: value})
      {:ok, %Theme{}}

      iex> create_theme(%{field: bad_value})
      {:error, ...}

  """
  def create_theme(attrs) do
    %Theme{}
    |> Theme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a theme.

  ## Examples

      iex> update_theme(theme, %{field: new_value})
      {:ok, %Theme{}}

      iex> update_theme(theme, %{field: bad_value})
      {:error, ...}

  """
  def update_theme(%Theme{} = theme, attrs) do
    theme
    |> Theme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Theme.

  ## Examples

      iex> delete_theme(theme)
      {:ok, %Theme{}}

      iex> delete_theme(theme)
      {:error, ...}

  """
  def delete_theme(%Theme{} = theme), do: Repo.delete(theme)

  @doc """
  Returns a data structure for tracking theme changes.
  """
  def change_theme(%Theme{} = theme, attrs \\ %{}) do
    Theme.changeset(theme,attrs)
  end

  @doc """
  Saves a user's selected themes with positions.

  `selected_themes` is a map with position => theme_id as strings:
  %{"1" => "17", "2" => "26"}
  """
  def save_user_themes(user_id, selected_themes) do
    Repo.transaction(fn ->
      # Delete existing user_themes for this user to proper update
      from(ut in UserTheme, where: ut.user_id == ^user_id)
      |> Repo.delete_all()

      # Insert new selections
      Enum.each(selected_themes, fn {position, theme_id} ->
        attrs = %{
          user_id: user_id,
          theme_id: String.to_integer(theme_id),
          position: String.to_integer(position)
        }

        %UserTheme{}
        |> UserTheme.changeset(attrs)
        |> Repo.insert!()
      end)
    end)
  end

  @doc """
  Returns a map of a user's selected themes with their positions.
  """
  def get_user_positions(user_id) do
    from(ut in UserTheme, where: ut.user_id == ^user_id)
    |> Repo.all()
    |> Map.new(fn ut -> {Integer.to_string(ut.position), Integer.to_string(ut.theme_id)} end)
  end

  @doc """
  Creates a contrast.
  """
  def create_contrast(attrs) do
    %Contrast{}
    |> Contrast.changeset(attrs)
    |> Repo.insert()
  end
end
