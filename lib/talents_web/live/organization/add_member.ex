defmodule TalentsWeb.Organization.AddMember do
  use TalentsWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="fixed inset-0 bg-black bg-opacity-20 flex items-center justify-center z-50">
      <div class="bg-gray-400 p-6 rounded shadow-xl w-96 space-y-4">
        <h2 class="text-xl font-semibold">Add Member</h2>

        <form phx-submit="add_member" phx-target={@myself} id="add-member-form">
          <label class="block text-sm font-medium">Email</label>
          <input
            name="email"
            type="email"
            class="w-full border rounded p-2"
            placeholder="user@example.com"
            required
          />

          <div class="flex justify-end space-x-3 mt-4">
            <button
              type="button"
              phx-click="close"
              phx-target={@myself}
              class="bg-red-200 px-3 py-1 rounded"
            >
              Cancel
            </button>

            <button class="bg-green-600 text-white px-3 py-1 rounded">
              Add Member
            </button>
          </div>
        </form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("add_member", %{"email" => email}, socket) do
    send(self(), {:add_member_email_provided, email})
    {:noreply, socket}
  end

  @impl true
  def handle_event("close", _, socket) do
    send(self(), :close_add_member_modal)
    {:noreply, socket}
  end
end
