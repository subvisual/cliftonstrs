defmodule TalentsWeb.Organization.OrganizationCreate do
  use TalentsWeb, :live_view

  alias Talents.{Repo, Organization, OrgUser}

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-md mx-auto">
      <h1 class="text-2xl font-bold mb-4">Create Organization</h1>

      <.form
        for={@form}
        id="org_form"
        phx-submit="save"
        phx-change="validate"
      >
        <.input
          field={@form[:name]}
          type="text"
          label="Organization name"
          required
        />

        <.input
          field={@form[:avatar]}
          type="text"
          label="Avatar Path (TBC)"
          required
        />

        <.button
          phx-disable-with="Creating..."
          class="btn btn-primary w-full"
        >
          Create Organization
        </.button>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    changeset = Organization.changeset(%Organization{}, %{})

    {:ok, assign_form(socket, changeset), temporary_assigns: [form: nil]}
  end

  @impl true
  def handle_event("save", %{"organization" => params}, socket) do
    user_id = socket.assigns.current_scope.user.id
    params = Map.put(params, "admin_id", user_id)

    case Talents.create_organization(params) do
      {:ok, org} ->
        %OrgUser{org_id: org.id, user_id: user_id}
        |> OrgUser.changeset(%{})
        |> Repo.insert()

        {:noreply,
         socket
         |> put_flash(:info, "Organization created!")
         |> push_navigate(to: ~p"/users/organizations")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  @impl true
  def handle_event("validate", %{"organization" => params}, socket) do
    changeset =
      %Organization{}
      |> Organization.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "organization")
    assign(socket, form: form)
  end
end
