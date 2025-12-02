defmodule TalentsWeb.Organization.OrganizationForm do
  alias Hex.API.Key.Organization
  use TalentsWeb, :live_view

  alias Talents.Organizations
  alias Talents.Organizations.Organization

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-xl mx-auto">
      <h2 class="text-2xl font-bold mb-6">
        {if @live_action == :new, do: "Create Organization", else: "Edit Organization"}
      </h2>

      <.form for={@form} phx-submit="save" phx-change="validate">
        <.input field={@form[:name]} type="text" label="Organization name" required />

        <.input field={@form[:avatar]} type="text" label="Avatar URL" />

        <.button class="btn btn-primary w-full mt-4" phx-disable-with="Saving...">
          {if @live_action == :new, do: "Create", else: "Save changes"}
        </.button>
      </.form>
    </div>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    case socket.assigns.live_action do
      :new ->
        changeset = Organizations.change_organization(%Organization{})

        {:ok,
         socket
         |> assign(:organization, %Organization{})
         |> assign(:form, to_form(changeset))}

      :edit ->
        id = params["id"]
        org = Organizations.get_organization_info(id)

        changeset = Organization.changeset(org, %{})

        {:ok,
         socket
         |> assign(:organization, org)
         |> assign(:form, to_form(changeset))}
    end
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
    case socket.assigns.live_action do
      :new -> create_org(socket, params)
      :edit -> update_org(socket, params)
    end
  end

  defp create_org(socket, params) do
    user_id = socket.assigns.current_scope.user.id
    params = Map.put(params, "admin_id", user_id)

    case Organizations.create_organization(params) do
      {:ok, org} ->
        Organizations.add_member_to_org(user_id, org.id)

        {:noreply,
         socket
         |> put_flash(:info, "Organization created!")
         |> push_navigate(to: ~p"/users/organizations")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_org(socket, params) do
    org = socket.assigns.organization

    case Organizations.update_organization(org, params) do
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
