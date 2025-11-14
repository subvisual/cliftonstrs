defmodule TalentsWeb.Organization.OrganizationLive do
  use TalentsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-4">Your Organizations</h1>

      <%= if @organizations == [] do %>
        <p class="text-gray-600">You are not part of any organizations.</p>
      <% else %>
        <ul class="space-y-3">
          <%= for org <- @organizations do %>
            <li class="p-3 border rounded">
              <div class="font-semibold">{org.name}</div>
              <div class="text-sm text-gray-600">
                Admin: {org.admin.name}
              </div>
            </li>
          <% end %>
        </ul>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id
    orgs = Talents.get_user_organizations(user_id)

    {:ok, assign(socket, :organizations, orgs)}
  end
end
