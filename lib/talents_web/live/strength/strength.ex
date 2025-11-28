defmodule TalentsWeb.Strength.StrengthLive do
  use TalentsWeb, :live_view

  @talent_ranks 34

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
              talents={@talents}
              selected_talents={@selected_talents}
            />
          <% end %>
        </div>

        <div>
          <%= for rank <- Enum.slice(@ranks, 5, 5) do %>
            <.live_component
              module={TalentsWeb.Strength.RankSelectComponent}
              id={"rank_select_#{rank}"}
              rank={rank}
              talents={@talents}
              selected_talents={@selected_talents}
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
            talents={@talents}
            selected_talents={@selected_talents}
          />
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

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_scope.user.id
    talents = Talents.get_talents()
    previous_select = Talents.get_user_positions(user_id)

    socket =
      socket
      |> assign(:talents, talents)
      |> assign(:selected_talents, previous_select)
      |> assign(:ranks, Enum.map(1..@talent_ranks, &Integer.to_string/1))

    {:ok, socket}
  end

  def handle_event("select_talent", %{"_target" => [changed_key]} = params, socket) do
    # changed_key == "talent_N"
    rank = String.slice(changed_key, 7..-1//1)
    talent = Map.get(params, changed_key, "")

    selected =
      case talent do
        "" -> Map.delete(socket.assigns.selected_talents, rank)
        _ -> Map.put(socket.assigns.selected_talents, rank, talent)
      end

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

  def handle_info({:rankings_imported, rankings}, socket) do
    # %{position_from_pdf => talent_id}
    imported =
      Map.new(
        socket.assigns.talents,
        fn t ->
          {Map.get(rankings, t.name, ""), Integer.to_string(t.id)}
        end
      )

    {:noreply, assign(socket, :selected_talents, imported)}
  end
end
