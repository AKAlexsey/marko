defmodule MarkoWeb.PageA do
  @moduledoc false

  use Phoenix.LiveView

  alias Marko.Components.Navigation
  alias MarkoWeb.LiveSessionCallbacks.TrackPagesVisited

  @navigation_configuration [
    {"Page B", "/page_b"},
    {"Page C tab 1", "/page_c/tab_1"}
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :navigation_configuration, @navigation_configuration)}
  end

  def handle_params(params, uri, socket) do
    {:noreply, TrackPagesVisited.assign_page_path(socket, uri)}
  end

  def terminate(_reason, socket) do
    TrackPagesVisited.on_terminate(socket)
  end
end
