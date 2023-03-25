defmodule MarkoWeb.PageA do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation
  alias MarkoWeb.Tracking.TrackPagesVisited

  @navigation_configuration [
    {"Page B", "/page_b"},
    {"Page C tab 1", "/page_c/tab_1"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :navigation_configuration, @navigation_configuration)}
  end

  def handle_params(_params, uri, socket) do
    {:noreply, TrackPagesVisited.assign_page_path(socket, uri)}
  end

  def terminate(_reason, socket) do
    TrackPagesVisited.on_terminate(socket)
  end

  def handle_event("visibility_changed", params, socket) do
    TrackPagesVisited.visibility_changed(socket, params)
  end
end
