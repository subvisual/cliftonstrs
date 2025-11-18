defmodule TalentsWeb.Organization.OrganizationEdit do
  use TalentsWeb, :live_view

  alias Talents.Organization

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto">
      <h2 class="text-2xl font-bold mb-6">Edit Organization</h2>

      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input
          field={@form[:name]}
          type="text"
          label="Organization name"
          required
        />

        <.input
          field={@form[:avatar]}
          type="text"
          label="Avatar URL"
        />

        <.button
          phx-disable-with="Saving..."
          class="btn btn-primary w-full mt-4"
        >
          Save changes
        </.button>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    org = Talents.get_organization_info(id)

    form =
      org
      |> Organization.changeset(%{})
      |> to_form()

    socket =
      socket
      |> assign(:organization, org)
      |> assign(:form, form)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"organization" => params}, socket) do
    changeset =
      socket.assigns.organization
      |> Organization.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  @impl true
  def handle_event("save", %{"organization" => params}, socket) do
    org = socket.assigns.organization

    case Talents.update_organization(org, params) do
      {:ok, updated} ->
        {:noreply,
         socket
         |> put_flash(:info, "Organization updated!")
         |> push_navigate(to: ~p"/users/organizations/#{updated.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
