defmodule Talents do
  @moduledoc """
  Talents keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  import Ecto.Query, warn: false
  alias Talents.Repo
  alias Talents.Talent

  @doc """
  Returns a list of all talents with only their id and name.
  """
  def get_talents() do
    from(t in Talent, select: %{id: t.id, name: t.name})
    |> Repo.all()
    |> Enum.sort_by(fn t ->  t.name end)
  end
end
