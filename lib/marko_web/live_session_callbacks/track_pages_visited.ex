defmodule MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
  @moduledoc """
  Gets Session ID from session map. Gets view from Socket. Tracks
  """

  def on_mount(:default, params, session, socket) do
    {:cont, socket}
  end
end
