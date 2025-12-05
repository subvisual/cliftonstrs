defmodule TalentsWeb.UserLive.Onboarding do
  use TalentsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-3xl mx-auto py-10">
      <h1 class="text-3xl font-bold mb-6">Welcome! Here's a quick tour</h1>

      <p class="mb-8">
        This short guide explains the elements you'll see in your navigation bar,
        so you know where everything lives.
      </p>
      
    <!-- PROFILE -->
      <section class="mb-10">
        <h2 class="text-2xl font-semibold mb-2">Profile</h2>
        <p class="mb-4">
          Your <strong>Profile</strong> page shows your core themes, personal overview, and
          information that helps others understand who you are.
        </p>
      </section>
      
    <!-- SETTINGS -->
      <section class="mb-10">
        <h2 class="text-2xl font-semibold mb-2">Settings</h2>
        <p class="mb-4">
          The <strong>Settings</strong> page lets you update your account information:
          email, password and name.
        </p>
      </section>
      
    <!-- STRENGTHS -->
      <section class="mb-10">
        <h2 class="text-2xl font-semibold mb-2">Strengths</h2>
        <p class="mb-4">
          The <strong>Strengths</strong> page is where you define and organize your themes.
          You can rank them, manage their order, and optionally <strong>import your PDF
            results</strong> if you have them.
          This shapes the profile themes shown elsewhere in the app.
        </p>
      </section>
      
    <!-- ORGANIZATIONS -->
      <section class="mb-10">
        <h2 class="text-2xl font-semibold mb-2">Organizations</h2>
        <p class="mb-4">
          The <strong>Organizations</strong> page shows groups you belong to.
          From here, you can view existing organizations or create new ones.
          These spaces help structure teams, groups, or entities you're part of.
        </p>
      </section>

      <hr class="my-10" />

      <p class="text-lg">
        You're all set! Use the navigation bar at the top anytime to move between
        these pages.
        Enjoy exploring your account and setting things up the way you like.
      </p>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
