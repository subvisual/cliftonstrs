defmodule TalentsWeb.StrengthLive do
  use TalentsWeb, :live_view

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold mb-6">CliftonStrengths Ranking</h1>

    <!-- The key fix: phx-change moved to the form -->
    <form phx-change="select_talent" phx-submit="save" class="space-y-8">
      <!-- Two columns: ranks 1 to 5 (left), 6 to 10 (right) -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div>
          <%= for rank <- Enum.slice(@ranks, 0, 5) do %>
            <.rank_select rank={rank} talents={@talents} selected_talents={@selected_talents} />
          <% end %>
        </div>

        <div>
          <%= for rank <- Enum.slice(@ranks, 5, 5) do %>
            <.rank_select rank={rank} talents={@talents} selected_talents={@selected_talents} />
          <% end %>
        </div>
      </div>
      
    <!-- Grid below: ranks 11 to 34 -->
      <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <%= for rank <- Enum.slice(@ranks, 10, 24) do %>
          <.rank_select rank={rank} talents={@talents} selected_talents={@selected_talents} />
        <% end %>
      </div>

      <div class="mt-8">
        <button
          type="submit"
          class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
          disabled={Enum.count(@selected_talents) < 34}
        >
          Save
        </button>
      </div>
    </form>
    """
  end

  attr :rank, :string, required: true
  attr :talents, :list, required: true
  attr :selected_talents, :map, required: true

  defp rank_select(assigns) do
    ~H"""
    <div class="flex items-center mb-3">
      <span class="font-bold w-8">{@rank}.</span>
      <select
        name={"talent_#{@rank}"}
        class="border rounded p-2 flex-1 bg-white text-gray-900 dark:text-gray-100"
      >
        <option value="">Select talent</option>
        <%= for talent <- @talents do %>
          <option
            value={talent.id}
            selected={@selected_talents[@rank] == Integer.to_string(talent.id)}
            disabled={
              Integer.to_string(talent.id) in Map.values(@selected_talents) &&
                @selected_talents[@rank] != Integer.to_string(talent.id)
            }
          >
            {talent.name}
          </option>
        <% end %>
      </select>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id
    talents = Talents.get_talents()
    previous_select = Talents.get_user_positions(user_id)

    socket =
      socket
      |> assign(:talents, talents)
      |> assign(:selected_talents, previous_select)
      |> assign(:ranks, Enum.map(1..34, &Integer.to_string/1))

    {:ok, socket}
  end

  def handle_event("select_talent", params, socket) do
    selected =
      params
      |> Enum.filter(fn {key, talent} -> String.starts_with?(key, "talent_") and talent != "" end)
      |> Map.new(fn {"talent_" <> rank, talent} -> {rank, talent} end)

    {:noreply, assign(socket, :selected_talents, selected)}
  end

  def handle_event("save", _params, socket) do
    user_id = socket.assigns.current_scope.user.id
    selected = socket.assigns.selected_talents

    Talents.save_user_talents(user_id, selected)

    {:noreply,
     socket
     |> put_flash(:info, "Strengths saved successfully!")
     |> push_navigate(to: ~p"/")}
  end
end
