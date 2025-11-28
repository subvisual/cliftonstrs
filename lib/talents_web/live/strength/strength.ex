defmodule TalentsWeb.Strength.StrengthLive do
  alias Talents.Themes
  use TalentsWeb, :live_view

  @themes_ranks 34

  def render(assigns) do
    ~H"""
    <h1 class="text-2xl font-bold mb-6">CliftonStrengths Ranking</h1>

    <.live_component
      module={TalentsWeb.Strength.RankImportComponent}
      id="rankings-upload"
    />

    <!-- The key fix: phx-change moved to the form -->
    <form phx-submit="save" class="space-y-8">
      <!-- Two columns: ranks 1 to 5 (left), 6 to 10 (right) -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div>
          <%= for rank <- Enum.slice(@ranks, 0, 5) do %>
            <.live_component
              module={TalentsWeb.Strength.RankSelectComponent}
              id={"rank_select_#{rank}"}
              rank={rank}
              themes={@themes}
              selected_themes={@selected_themes}
            />
          <% end %>
        </div>

        <div>
          <%= for rank <- Enum.slice(@ranks, 5, 5) do %>
            <.live_component
              module={TalentsWeb.Strength.RankSelectComponent}
              id={"rank_select_#{rank}"}
              rank={rank}
              themes={@themes}
              selected_themes={@selected_themes}
            />
          <% end %>
        </div>
      </div>

    <!-- Grid below: ranks 11 to 34 -->
      <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
        <%= for rank <- Enum.slice(@ranks, 10, 24) do %>
          <.live_component
            module={TalentsWeb.Strength.RankSelectComponent}
            id={"rank_select_#{rank}"}
            rank={rank}
            themes={@themes}
            selected_themes={@selected_themes}
          />
        <% end %>
      </div>

      <div class="mt-8">
        <button
          type="submit"
          class="bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700 disabled:opacity-50"
          disabled={Enum.count(@selected_themes) < 34}
        >
          Save
        </button>
      </div>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id
    themes = Themes.list_themes()
    previous_select = Themes.get_user_positions(user_id)

    socket =
      socket
      |> assign(:themes, themes)
      |> assign(:selected_themes, previous_select)
      |> assign(:ranks, Enum.map(1..@themes_ranks, &Integer.to_string/1))

    {:ok, socket}
  end

  def handle_event("select_theme", %{"_target" => [changed_key]} = params, socket) do
    # changed_key == "theme_N"
    rank = String.slice(changed_key, 7..-1//1)
    theme = Map.get(params, changed_key, "")

    selected =
      case theme do
        "" -> Map.delete(socket.assigns.selected_themes, rank)
        _ -> Map.put(socket.assigns.selected_themes, rank, theme)
      end

    {:noreply, assign(socket, :selected_themes, selected)}
  end

  def handle_event("save", _params, socket) do
    user_id = socket.assigns.current_scope.user.id
    selected = socket.assigns.selected_themes

    Themes.save_user_themes(user_id, selected)

    {:noreply,
     socket
     |> put_flash(:info, "Strengths saved successfully!")
     |> push_navigate(to: ~p"/")}
  end

  def handle_info({:rankings_imported, rankings}, socket) do
    # %{position_from_pdf => theme_id}
    imported =
      Map.new(
        socket.assigns.themes,
        fn t ->
          {Map.get(rankings, t.name, ""), Integer.to_string(t.id)}
        end
      )

    {:noreply, assign(socket, :selected_themes, imported)}
  end
end
