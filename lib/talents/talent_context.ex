defmodule Talents.TalentContext do
  @moduledoc """
  The TalentContext context.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo

  alias Talents.Talent.{UserTalent, Talent}

  @doc """
  Returns the list of talents.

  ## Examples

      iex> list_talents()
      [%Talent{}, ...]

  """
  def list_talents do
    from(t in Talent, select: %{id: t.id, name: t.name})
    |> Repo.all()
    |> Enum.sort_by(fn t -> t.name end)
  end

  @doc """
  Gets a single talent.

  Raises if the Talent does not exist.

  ## Examples

      iex> get_talent!(123)
      %Talent{}

  """
  def get_talent!(id), do: Repo.get!(Talent, id)

  @doc """
  Creates a talent.

  ## Examples

      iex> create_talent(%{field: value})
      {:ok, %Talent{}}

      iex> create_talent(%{field: bad_value})
      {:error, ...}

  """
  def create_talent(attrs) do
    %Talent{}
    |> Talent.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a talent.

  ## Examples

      iex> update_talent(talent, %{field: new_value})
      {:ok, %Talent{}}

      iex> update_talent(talent, %{field: bad_value})
      {:error, ...}

  """
  def update_talent(%Talent{} = talent, attrs) do
    talent
    |> Talent.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Talent.

  ## Examples

      iex> delete_talent(talent)
      {:ok, %Talent{}}

      iex> delete_talent(talent)
      {:error, ...}

  """
  def delete_talent(%Talent{} = talent), do: Repo.delete(talent)

  @doc """
  Returns a data structure for tracking talent changes.

  ## Examples

      iex> change_talent(talent)
      %Todo{...}

  """
  def change_talent(%Talent{} = talent, attrs \\ %{}) do
    Talent.changeset(talent,attrs)
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
end
