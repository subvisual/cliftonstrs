defmodule Talents.Accounts.UserNotifier do
  import Swoosh.Email

  alias Talents.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Talents", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.name},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver a welcome message to the new user.
  """
  def deliver_login_instructions(user, login_url, onboarding_url) do
    deliver(
      user.email,
      "Welcome to Talents!",
      """

      ==============================

      Hi #{user.name},

      Welcome to Talents! Your account is ready.

      You can access your dashboard using the link below:

      #{login_url}

      To help you get started, we also prepared a quick introduction to each section
      of your account:

      #{onboarding_url}

      If you didn't create an account with us, please contact our support team.

      We're excited to have you on board!

      ==============================
      """
    )
  end

  @doc """
  Deliver an added to the organization message to the user email.
  """
  def deliver_added_to_organization(user, org_name, url) do
    deliver(user.email, "Joined #{org_name}", """

    ==============================

    Hi #{user.name},

    You've been added to #{org_name}! You can check it here:

    #{url}

    ==============================
    """)
  end
end
