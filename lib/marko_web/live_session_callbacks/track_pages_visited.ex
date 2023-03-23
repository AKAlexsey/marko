defmodule MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
  @moduledoc """
  Gets Session ID from session map. Gets view from Socket. Tracks
  """

  alias Marko.Monitoring

  def on_mount(:default, params, session, socket) do
    {:cont, socket}
  end
end
