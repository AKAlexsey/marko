defmodule MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
  @moduledoc """
  Gets Session ID from session map. Gets view from Socket. Tracks
  """

  import Phoenix.Component, only: [assign: 3]

  alias Marko.Monitoring

  def on_mount(:default, _params, session, %{assigns: assigns} = socket) do
    %{"session_id" => session_id, "user_agent" => user_agent} = session
    %{view: current_view} = socket

    IO.puts("!!! #{__MODULE__} session #{inspect(session, pretty: true)}")
    IO.puts("!!! #{__MODULE__} socket assigns #{inspect(socket.assigns, pretty: true)}")

    new_socket = case assigns do
       %{view: ^current_view, visit_started: %NaiveDateTime{}} ->
         IO.puts("!!! case #1")
         socket

      %{view: view, visit_started: %NaiveDateTime{} = visit_started} ->
        IO.puts("!!! case #2")
        track_time_spent(session_id, view, visit_started, %{user_agent: user_agent})
        start_tracking_view_time_spent(socket, current_view)

      _ ->
        IO.puts("!!! case #3")
        start_tracking_view_time_spent(socket, current_view)
    end
    |> tap(fn res -> IO.puts("!!! result socket #{inspect(res)}") end)

    {:cont, new_socket}
  end

  defp track_time_spent(session_id, view, visit_started, metadata) do
    seconds_spent = NaiveDateTime.diff(NaiveDateTime.utc_now(), visit_started)
    Monitoring.track_user_activity(session_id, view, seconds_spent, metadata)
  end

  defp start_tracking_view_time_spent(socket, view) do
    socket
    |> assign(:view, view)
    |> assign(:visit_started, NaiveDateTime.utc_now())
  end
end
