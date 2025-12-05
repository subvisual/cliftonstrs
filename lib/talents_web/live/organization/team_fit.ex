defmodule TalentsWeb.Organization.TeamFit do
  use TalentsWeb, :live_view
  alias Talents.Organizations
  alias Talents.Themes

  def render(assigns) do
    ~H"""
    <div class="max-w-4xl mx-auto p-8 space-y-10">
      <h1 class="text-3xl font-bold">
        Team Fit - {@organization.name}
      </h1>

    <!-- Member Selection Panel -->
      <div class="border p-4 rounded-lg">
        <h2 class="text-xl font-semibold mb-4">Select Members</h2>

        <div class="space-y-3">
          <%= for {member, selected} <- @members do %>
            <label class="flex items-center space-x-3">
              <input
                type="checkbox"
                phx-click="toggle_member"
                phx-value-id={member.id}
                checked={selected}
              />
              <span>{member.name}</span>
            </label>
          <% end %>
        </div>

        <.button
          phx-click="fit"
          class="mt-4 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        >
          Fit
        </.button>
      </div>

    <!-- Results -->
      <%= if @selected_personas != [] do %>
        <div class="space-y-10">
          <%= for member <- @selected_personas do %>
            <div class="p-6 border rounded-lg shadow-sm">

    <!-- Member Identity -->
              <div class="flex items-center space-x-4 mb-6">
                <div>
                  <h2 class="text-2xl font-bold">{member.name}</h2>
                </div>
              </div>

              <h3 class="text-xl font-semibold mb-2">Top Themes</h3>

              <%= for theme <- member.top_themes do %>
                <details class="border rounded-lg mb-4 shadow-sm">
                  <summary class="cursor-pointer p-4 flex justify-between items-center list-none">
                    <span class="text-lg font-semibold">{theme.name}</span>
                    <span class="text-gray-500">▼</span>
                  </summary>

                  <div class="p-4 border-t text-gray-700 space-y-2">
                    <p><strong>Description:</strong> {theme.description}</p>
                    <p><strong>I am:</strong> {theme.i_am}</p>
                    <p><strong>I will:</strong> {theme.i_will}</p>
                    <p><strong>I love:</strong> {theme.i_love}</p>
                    <p><strong>I dislike:</strong> {theme.i_dislike}</p>
                    <p><strong>I bring:</strong> {theme.i_bring}</p>
                    <p><strong>I need:</strong> {theme.i_need}</p>
                    <p><strong>Metaphor:</strong> {theme.metaphor_image}</p>
                    <p><strong>Barrier:</strong> {theme.barrier_label}</p>
                  </div>
                </details>
              <% end %>
            </div>
          <% end %>
        </div>
      <% else %>
        <p class="text-gray-600 text-lg">
          Select members and press <strong>Fit</strong> to see their personas.
        </p>
      <% end %>
    </div>
    """
  end

  def mount(%{"id" => org_id}, _session, socket) do
    organization = Organizations.get_organization_info(org_id)

    members =
      Enum.map(organization.users, fn u ->
        {%{id: u.id, name: u.name}, false}
      end)

    {:ok,
     socket
     |> assign(:organization, organization)
     |> assign(:members, members)
     |> assign(:persona, [])}
  end

  def handle_event("toggle_member", %{"id" => id}, socket) do
    members =
      Enum.map(socket.assigns.members, fn {%{id: m_id} = m, selected} ->
        if "#{m_id}" == id, do: {m, !selected}, else: {m, selected}
      end)

    {:noreply, assign(socket, :members, members)}
  end

  def handle_event("fit", _params, socket) do
    selected =
      socket.assigns.members
      |> Enum.filter(fn {_, selected?} -> selected? end)
      |> Enum.map(fn {m, _} -> m end)

    {:noreply, assign(socket, :personas, personas)}
  end
end
