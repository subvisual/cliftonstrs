defmodule TalentsWeb.Strength.RankSelectComponent do
  use TalentsWeb, :live_component

  attr :id, :string, required: true
  attr :rank, :string, required: true
  attr :talents, :list, required: true
  attr :selected_talents, :map, required: true

  def render(assigns) do
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
end
