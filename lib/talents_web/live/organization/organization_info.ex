defmodule TalentsWeb.Organization.OrganizationInfo do
  use TalentsWeb, :live_view

  alias Talents.Accounts
  alias Talents.Accounts.UserNotifier
  alias Talents.Organizations
  alias Talents.Themes

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

      <.button
        :if={@is_admin?}
        phx-click="open_add_member_modal"
        class="bg-green-600 text-white px-4 py-2 ml-6 rounded hover:bg-green-700"
      >
        Add Member
      </.button>

      <%= if @show_add_member_modal do %>
        <.live_component
          module={TalentsWeb.Organization.AddMember}
          id="add-member-modal"
        />
      <% end %>

    <!-- Member List -->
      <div>
        <h2 class="text-xl font-semibold mt-2 mb-2">Members</h2>

        <%= if Enum.empty?(@organization.users) do %>
          <p class="text-gray-600">No members yet.</p>
        <% else %>
          <ul class="space-y-3">
            <%= for orguser <- @organization.users do %>
              <li class="p-3 border rounded flex items-center space-x-3">
                <div class="flex-1">
                  <p class="font-semibold">{orguser.name}</p>
                  <p class="text-gray-600 text-sm">{orguser.email}</p>
                </div>

                <span
                  :if={orguser.id == @current_scope.user.id}
                  class="text-xs bg-green-100 text-green-700 px-2 py-1 rounded"
                >
                  You
                </span>

                <span
                  :if={orguser.id == @organization.admin_id}
                  class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded"
                >
                  Admin
                </span>

                <.button
                  :if={@is_admin? and orguser.id != @organization.admin_id}
                  phx-click="update_admin"
                  phx-value-user-id={orguser.id}
                  data-confirm="Are you sure you want to make this user the new admin?"
                  class="bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-2 py-1 rounded text-xs"
                >
                  Make Admin
                </.button>

                <.button
                  :if={@is_admin? and orguser.id != @organization.admin_id}
                  phx-click="remove_member"
                  phx-value-user-id={orguser.id}
                  data-confirm="Are you sure you want to remove this member?"
                  class="bg-red-100 text-red-600 hover:bg-red-200 px-2 py-1 rounded text-xs"
                >
                  Remove
                </.button>
              </li>
            <% end %>
          </ul>
        <% end %>
      </div>

      <.button
        :if={@is_admin?}
        phx-click="delete_organization"
        data-confirm="Are you sure you want to delete this organization? This cannot be undone."
        class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700"
      >
        Delete Organization
      </.button>

      <div class="mt-8">
        <h2 class="text-xl font-semibold mb-4">Theme Distribution</h2>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
          <%= for {{name, domain}, count} <- @distribution do %>
            <div class="p-2 border rounded">
              <p class="font-semibold">{name}</p>
              <p class="text-sm text-gray-600">{domain}</p>
              <p class="text-lg">{count}</p>
            </div>
          <% end %>
        </div>
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
    org = Organizations.get_organization_info(id)
    is_admin? = org.admin_id == socket.assigns.current_scope.user.id

    dist = Themes.theme_distribution(org.users)

    socket =
      socket
      |> assign(:organization, org)
      |> assign(:is_admin?, is_admin?)
      |> assign(:show_add_member_modal, false)
      |> assign(:distribution, dist)

    {:ok, socket}
  end

  @impl true
  def handle_info({:add_member_email_provided, email}, socket) do
    org = socket.assigns.organization
    org_id = org.id

    case Accounts.get_user_by_email(email) do
      nil ->
        {:noreply,
         socket
         |> put_flash(:error, "No user found with email #{email}")}

      user ->
        # Add user to org
        Organizations.add_member_to_org(user.id, org_id)

        # Send email notification
        org_url = url(~p"/users/organizations/#{org_id}")
        {:ok, _} = UserNotifier.deliver_added_to_organization(user, org.name, org_url)

        new_org = Organizations.get_organization_info(org_id)

        {:noreply,
         socket
         |> put_flash(:info, "#{user.name} added to the organization!")
         |> assign(:organization, new_org)
         |> assign(:show_add_member_modal, false)}
    end
  end

  def handle_info(:close_add_member_modal, socket) do
    {:noreply, assign(socket, :show_add_member_modal, false)}
  end

  def handle_event("open_add_member_modal", _, socket) do
    {:noreply, assign(socket, :show_add_member_modal, true)}
  end

  @impl true
  def handle_event("remove_member", %{"user-id" => user_id}, socket) do
    org_id = socket.assigns.organization.id
    user_id = String.to_integer(user_id)

    case Organizations.remove_member(org_id, user_id) do
      {1, _} ->
        org = Organizations.get_organization_info(org_id)
        is_admin? = org.admin_id == socket.assigns.current_scope.user.id

        {:noreply,
         socket
         |> put_flash(:info, "Member removed!")
         |> assign(:organization, org)
         |> assign(:is_admin?, is_admin?)}

      {0, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Could not remove member.")}
    end
  end

  @impl true
  def handle_event("update_admin", %{"user-id" => user_id}, socket) do
    org_id = socket.assigns.organization.id
    new_admin_id = String.to_integer(user_id)

    case Organizations.update_admin(org_id, new_admin_id) do
      {1, _} ->
        org = Organizations.get_organization_info(org_id)
        is_admin? = org.admin_id == socket.assigns.current_scope.user.id

        {:noreply,
         socket
         |> put_flash(:info, "Admin updated!")
         |> assign(:organization, org)
         |> assign(:is_admin?, is_admin?)}

      {0, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Admin update failed — this user is not a member.")}
    end
  end

  @impl true
  def handle_event("delete_organization", _params, socket) do
    org = socket.assigns.organization

    case Organizations.delete_organization(org) do
      {:ok, _} ->
        {:noreply,
         socket
         |> push_navigate(to: ~p"/users/organizations")}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Delete failed: #{inspect(reason)}")}
    end
  end
end
