defmodule Talents.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TalentsWeb.Telemetry,
      Talents.Repo,
      {DNSCluster, query: Application.get_env(:talents, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Talents.PubSub},
      # Start a worker by calling: Talents.Worker.start_link(arg)
      # {Talents.Worker, arg},
      # Start to serve requests, typically the last entry
      TalentsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Talents.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TalentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
