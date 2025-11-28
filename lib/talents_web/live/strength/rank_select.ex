defmodule TalentsWeb.Strength.RankSelectComponent do
  use TalentsWeb, :live_component

  attr :id, :string, required: true
  attr :rank, :string, required: true
  attr :themes, :list, required: true
  attr :selected_themes, :map, required: true

  def render(assigns) do
    ~H"""
    <div class="flex items-center mb-3">
      <span class="font-bold w-8">{@rank}.</span>
      <select
        name={"theme_#{@rank}"}
        phx-change="select_theme"
        class="border rounded p-2 flex-1 bg-white text-gray-900 dark:text-gray-100"
      >
        <option value="">Select theme</option>
        <%= for theme <- @themes do %>
          <option
            value={theme.id}
            selected={@selected_themes[@rank] == Integer.to_string(theme.id)}
            disabled={
              Integer.to_string(theme.id) in Map.values(@selected_themes) &&
                @selected_themes[@rank] != Integer.to_string(theme.id)
            }
          >
            {theme.name}
          </option>
        <% end %>
      </select>
    </div>
    """
  end
end
