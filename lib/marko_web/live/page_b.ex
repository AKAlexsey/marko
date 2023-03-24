defmodule MarkoWeb.PageB do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation
  alias MarkoWeb.LiveSessionCallbacks.TrackPagesVisited

  @navigation_configuration [
    {"Page A", "/page_a"},
    {"Page C tab 2", "/page_c/tab_2"}
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
