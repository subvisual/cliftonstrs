defmodule TalentsWeb.Organization.OrganizationInfo do
  use TalentsWeb, :live_view

  alias Talents.{Repo, Organization}

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
      
    <!-- Member List -->
      <div>
        <h2 class="text-xl font-semibold mb-2">Members</h2>

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
                  :if={user.id == @organization.admin_id}
                  class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded"
                >
                  Admin
                </span>
              </li>
            <% end %>
          </ul>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    org =
      Organization
      |> Repo.get!(id)
      |> Repo.preload([:admin, :users])

    {:ok, assign(socket, :organization, org)}
  end
end
