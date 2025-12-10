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
    from(t in Theme, select: %{id: t.id, name: t.name, domain: t.domain})
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
    Theme.changeset(theme, attrs)
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

  @doc """
  Returns the user top 10 talents.
  """
  def get_user_top_themes(user_id) do
    from(ut in UserTheme,
      join: t in Theme,
      on: ut.theme_id == t.id,
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
    theme_map =
      list_themes()
      |> Map.new(fn t -> {{t.name, t.domain}, 0} end)

    user_list
    |> Enum.flat_map(fn u -> get_user_top_themes(u.id) end)
    |> Enum.reduce(
      theme_map,
      fn t, acc -> Map.update(acc, {t.name, t.domain}, 1, fn current -> current + 1 end) end
    )
    |> Enum.sort_by(fn {_k, v} -> v end, :desc)
  end

  @doc """
  Returns the contrast themes of a single theme.
  """
  def get_contrast_of_theme(theme_id) do
    from(c in Contrast, where: c.theme_id == ^theme_id)
    |> Repo.all()
    |> Enum.map(fn c -> get_theme!(c.contrast_id) end)
  end

  @doc """
  Returns the contrast themes of a single user.
  """
  def get_user_contrasts(user_id) do
    top_themes = get_user_top_themes(user_id)

    top_themes
    |> Enum.flat_map(fn t -> get_contrast_of_theme(t.id) end)
    |> Enum.uniq()
    |> Enum.reject(fn c -> Enum.member?(top_themes, c) end)
  end

  @doc """
  Get the persona (top 5 themes) of a group of users.
  """
  def get_persona([]), do: []

  def get_persona(user_list) do
    user_list
    |> theme_distribution()
    |> Enum.take(5)
    |> Enum.map(fn {{theme, _domain}, _q} -> Repo.get_by!(Theme, name: theme) end)
  end

  @doc """
  Returns the contrast phrase for a given theme and contrast ID.
  If no record is found, returns an empty string.
  """
  def get_contrast_phrase(theme_id, contrast_id) do
    case Repo.get_by(Contrast, theme_id: theme_id, contrast_id: contrast_id) do
      nil ->
        ""

      %Contrast{phrase: phrase} ->
        phrase
    end
  end

  @doc """
  Given a list of contrast IDs and a list of theme IDs,
  returns the list of phrases for all combinations.
  """
  def search_contrast(contrast_list, theme_list) do
    for t <- theme_list, c <- contrast_list do
      get_contrast_phrase(t.id, c.id)
    end
  end

  @doc """
  Compares two users by:
    • getting the top themes for each user,
    • finding contrasts user_one has that match themes of user_two,
    • returning tuples {user_one_name, user_two_name, phrase}.
  """
  def compare_contrast(user_one, user_two) do
    themes_one = get_user_top_themes(user_one.id)
    themes_two = get_user_top_themes(user_two.id)

    user_one.id
    |> get_user_contrasts()
    |> Enum.filter(fn c -> Enum.member?(themes_two, c) end)
    |> search_contrast(themes_one)
    |> Enum.map(fn ph -> {user_one.name, user_two.name, ph} end)
  end

  @doc """
  Takes a list of users and computes all "shocks" (contrasts) between
  every **distinct pair** of users.

  A *shock* is defined as a non-empty contrast result between two users.
  For each pair of different users, this function runs `compare_contrast/2`,
  filters out empty contrast entries, and returns a flattened list of all
  resulting shocks.

  Returns an empty list when given an empty list.
  """
  def get_shock([]), do: []

  def get_shock(selected) do
    for u1 <- selected, u2 <- selected, u1 != u2 do
      compare_contrast(u1, u2)
      |> Enum.filter(fn {_u1, _u2, ph} -> ph != "" end)
    end
    |> List.flatten()
  end
end
