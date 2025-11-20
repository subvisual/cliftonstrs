defmodule TalentsWeb.Organization.OrganizationInfo do
  use TalentsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6 max-w-3xl mx-auto space-y-6">

    <!-- Organization Header -->
      <div class="flex items-center space-x-4">
        <img
          :if={@organization.avatar}
          src={@organization.avatar}
          class="w-16 h-16 rounded-full border"
        />

        <div>
          <h1 class="text-3xl font-bold">{@organization.name}</h1>
          <p class="text-gray-600">
            Admin: {@organization.admin.name} ({@organization.admin.email})
          </p>
        </div>
      </div>

      <%= if @is_admin? do %>
        <.link
          navigate={~p"/users/organizations/#{@organization.id}/edit"}
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Edit Organization
        </.link>
      <% end %>

    <!-- Member List -->
      <div>
        <h2 class="text-xl font-semibold mt-2 mb-2">Members</h2>

        <%= if Enum.empty?(@organization.users) do %>
          <p class="text-gray-600">No members yet.</p>
        <% else %>
          <ul class="space-y-3">
            <%= for user <- @organization.users do %>
              <li class="p-3 border rounded flex items-center space-x-3">
                <div class="flex-1">
                  <p class="font-semibold">{user.name}</p>
                  <p class="text-gray-600 text-sm">{user.email}</p>
                </div>

                <span
                  :if={user.id == @current_scope.user.id}
                  class="text-xs bg-green-100 text-green-700 px-2 py-1 rounded"
                >
                  You
                </span>

                <span
                  :if={user.id == @organization.admin_id}
                  class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded"
                >
                  Admin
                </span>

                <%= if @is_admin? and user.id != @organization.admin_id do %>
                  <.button
                    phx-click="update_admin"
                    phx-value-user-id={user.id}
                    data-confirm="Are you sure you want to make this user the new admin?"
                    class="bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-2 py-1 rounded text-xs"
                  >
                    Make Admin
                  </.button>
                <% end %>

                <%= if @is_admin? and user.id != @organization.admin_id do %>
                  <.button
                    phx-click="remove_member"
                    phx-value-user-id={user.id}
                    data-confirm="Are you sure you want to remove this member?"
                    class="bg-red-100 text-red-600 hover:bg-red-200 px-2 py-1 rounded text-xs"
                  >
                    Remove
                  </.button>
                <% end %>
              </li>
            <% end %>
          </ul>
        <% end %>
      </div>
      <%= if @is_admin? do %>
        <.button
          phx-click="delete_organization"
          data-confirm="Are you sure you want to delete this organization? This cannot be undone."
          class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
        >
          Delete Organization
        </.button>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    org = Talents.get_organization_info(id)
    is_admin? = org.admin_id == socket.assigns.current_scope.user.id

    socket =
      socket
      |> assign(:organization, org)
      |> assign(:is_admin?, is_admin?)

    {:ok, socket}
  end

  @impl true
  def handle_event("remove_member", %{"user-id" => user_id}, socket) do
    org_id = socket.assigns.organization.id

    Talents.remove_member(org_id, String.to_integer(user_id))

    org = Talents.get_organization_info(org_id)
    is_admin? = org.admin_id == socket.assigns.current_scope.user.id

    {:noreply,
     socket
     |> put_flash(:info, "Member removed!")
     |> assign(:organization, org)
     |> assign(:is_admin?, is_admin?)}
  end

  @impl true
  def handle_event("update_admin", %{"user-id" => user_id}, socket) do
    org_id = socket.assigns.organization.id
    new_admin_id = String.to_integer(user_id)

    Talents.update_admin(org_id, new_admin_id)

    org = Talents.get_organization_info(org_id)
    is_admin? = org.admin_id == socket.assigns.current_scope.user.id

    {:noreply,
     socket
     |> put_flash(:info, "Admin updated!")
     |> assign(:organization, org)
     |> assign(:is_admin?, is_admin?)}
  end

  @impl true
  def handle_event("delete_organization", _params, socket) do
    org = socket.assigns.organization

    Talents.delete_organization(org)

    {:noreply,
     socket
     |> put_flash(:info, "Organization deleted successfully.")
     |> push_navigate(to: ~p"/users/organizations")}
  end
end
