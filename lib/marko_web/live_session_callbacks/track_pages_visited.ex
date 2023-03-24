defmodule MarkoWeb.LiveSessionCallbacks.TrackPagesVisited do
  @moduledoc """
  Gets Session ID from session map. Gets view from Socket. Tracks
  """

  import Phoenix.Component, only: [assign: 3]

  alias Marko.Monitoring

  @page_visible "visible"
  @page_hidden "hidden"

  def on_mount(:activity_tracking, _params, session, socket) do
    %{"session_id" => session_id, "user_agent" => user_agent} = session

    new_socket = assign_user_session_data(socket, session_id, user_agent)

    {:cont, new_socket}
  end

  defp assign_user_session_data(socket, session_id, user_agent) do
    socket
    |> assign(:form, Phoenix.Component.to_form(%{}))
    |> assign(:session_id, session_id)
    |> assign(:user_agent, user_agent)
    |> assign(:visit_started, NaiveDateTime.utc_now())
    |> assign(:visibility, "visible")
    |> assign(:seconds_spent, 0)
  end

  def on_terminate(%{view: view, assigns: assigns} = socket) do
    %{user_agent: user_agent, session_id: session_id, path: path} = assigns

    Monitoring.track_user_activity(%{
      view: "#{view}",
      session_id: session_id,
      path: path,
      seconds_spent: calculate_total_seconds_spend(assigns),
      metadata: %{user_agent: user_agent}
    })

    socket
  end

  def visibility_changed(%{assigns: assigns} = socket, %{"visibility" => current_visibility}) do
    %{visibility: past_visibility} = assigns

    new_socket =
      case current_visibility do
        ^past_visibility ->
          socket

        @page_visible ->
          assign(socket, :visit_started, NaiveDateTime.utc_now())

        @page_hidden ->
          socket
          |> assign(:visit_started, nil)
          |> assign(:seconds_spent, calculate_total_seconds_spend(assigns))
      end
      |> assign(:visibility, current_visibility)

    {:noreply, new_socket}
  end

  def assign_page_path(socket, uri) do
    %{path: path} = URI.parse(uri)

    assign(socket, :path, path)
  end

  defp calculate_total_seconds_spend(%{visit_started: visit_started, seconds_spent: seconds_spent}) do
    seconds_spent + NaiveDateTime.diff(NaiveDateTime.utc_now(), visit_started)
  end
end
