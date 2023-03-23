defmodule Marko.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarkoWeb.Telemetry,
      Marko.Repo,
      {Phoenix.PubSub, name: Marko.PubSub},
      {Finch, name: Marko.Finch},
      MarkoWeb.Endpoint,
      Marko.Monitoring.SessionTrackingWorker
    ]

    opts = [strategy: :one_for_one, name: Marko.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MarkoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
