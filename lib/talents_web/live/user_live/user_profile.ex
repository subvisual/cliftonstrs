defmodule TalentsWeb.UserLive.UserProfile do
  use TalentsWeb, :live_view

  alias Talents.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto p-6">
      <!-- User header -->
      <div class="flex items-center space-x-4 mb-6">
        <img
          :if={@user.avatar}
          src={@user.avatar}
          class="w-16 h-16 rounded-full border"
        />

        <div>
          <h1 class="text-3xl font-bold"><%= @user.name%></h1>
          <p class="text-gray-600"><%= @user.email%></p>
        </div>
      </div>

      <hr class="my-6" />

      <div>
        <h2 class="text-2xl font-semibold mb-3">Themes</h2>
        <p class="text-gray-500">Themes section — to be implemented later.</p>
      </div>
    </div>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    user = Accounts.get_user!(id)

    {:ok, assign(socket, user: user)}
  end
end
