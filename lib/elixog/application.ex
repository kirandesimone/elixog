defmodule Elixog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixogWeb.Telemetry,
      # Start the Ecto repository
      Elixog.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Elixog.PubSub},
      # Start Finch
      {Finch, name: Elixog.Finch},
      # Start the Endpoint (http/https)
      ElixogWeb.Endpoint
      # Start a worker by calling: Elixog.Worker.start_link(arg)
      # {Elixog.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Elixog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
