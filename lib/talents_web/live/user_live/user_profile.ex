defmodule TalentsWeb.UserLive.UserProfile do
  use TalentsWeb, :live_view

  alias Talents.Accounts
  alias Talents.Themes

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      
    <!-- Header -->
      <div class="flex items-center space-x-4 mb-6">
        <img :if={@user.avatar} src={@user.avatar} class="w-16 h-16 rounded-full border" />
        <div>
          <h1 class="text-3xl font-bold">{@user.name}</h1>
          <p class="text-gray-600">{@user.email}</p>
        </div>
      </div>

      <hr class="my-6" />
      <div>
        <h2 class="text-2xl font-semibold mb-3">Top 5 Themes</h2>

        <%= for theme <- @top_themes do %>
          <details class="border rounded-lg mb-4 shadow-sm">
            
    <!-- Header -->
            <summary class="cursor-pointer p-4 flex justify-between items-center list-none">
              <span class="text-xl font-bold">{theme.name}</span>
              <span class="text-gray-500">▼</span>
            </summary>
            
    <!-- Body -->
            <div class="p-4 border-t text-gray-50 space-y-2">
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
      <div class="mt-10">
        <h2 class="text-2xl font-semibold mb-3">You also excel in…</h2>
        <p class="text-gray-60 text-lg">
          {Enum.map(@bottom_themes, & &1.name) |> Enum.join(", ")}.
        </p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)
    themes = Themes.get_user_top_themes(id)

    {:ok,
     assign(socket,
       user: user,
       top_themes: Enum.take(themes, 5),
       bottom_themes: Enum.drop(themes, 5)
     )}
  end
end
