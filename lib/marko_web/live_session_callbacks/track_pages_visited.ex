defmodule MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
  @moduledoc """
  Gets Session ID from session map. Gets view from Socket. Tracks
  """

  import Phoenix.Component, only: [assign: 3]

  alias Marko.Monitoring

  def on_mount(:activity_tracking, _params, session, socket) do
    %{"session_id" => session_id, "user_agent" => user_agent} = session

    new_socket = assign_user_session_data(socket, session_id, user_agent)

    {:cont, new_socket}
  end

  defp assign_user_session_data(socket, session_id, user_agent) do
    socket
    |> assign(:session_id, session_id)
    |> assign(:user_agent, user_agent)
    |> assign(:visit_started, NaiveDateTime.utc_now())
  end

  def on_terminate(%{view: view, assigns: assigns} = socket) do
    %{user_agent: user_agent, session_id: session_id, visit_started: visit_started, path: path} =
      assigns

    seconds_spent = NaiveDateTime.diff(NaiveDateTime.utc_now(), visit_started)
    metadata = %{user_agent: user_agent}

    Monitoring.track_user_activity(%{
      view: "#{view}",
      session_id: session_id,
      path: path,
      seconds_spent: seconds_spent,
      metadata: metadata
    })

    socket
  end

  def assign_page_path(socket, uri) do
    %{path: path} = URI.parse(uri)

    assign(socket, :path, path)
  end
end
