defmodule MarkoWeb.Tracking.TrackPagesVisited do
  @moduledoc """
  The main business logic module. Consists of functions those:

  1. Assigns tracking data to the web socket
  2. Use tracking data for calculation of the time spent
  3. Send data to the monitoring gen server
  """

  import Phoenix.Component, only: [assign: 3]

  alias Marko.Monitoring

  @page_visible "visible"
  @page_hidden "hidden"

  @time_calculation_precision :millisecond

  @doc """
  Callback running between LiveView renderings.

  Assigns data for involvement calculations. Path, user session ID e.t.c.
  """
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
    |> assign(:visit_started, now())
    |> assign(:visibility, @page_visible)
    |> assign(:milliseconds_spent, 0)
  end

  @doc """
  Callback running during processing of the "visibilitychange" browser event callback.

  Assume to receive assigns defined in #on_mount/4 function

  Compares visibility state with current, saved in assigns.

  If it's the same - leave as is.

  If visibility state changed - calculates time page visible or saves visit datetime.
  """

  def visibility_changed(%{assigns: assigns} = socket, %{"visibility" => current_visibility}) do
    %{visibility: past_visibility} = assigns

    new_socket =
      case current_visibility do
        ^past_visibility ->
          socket

        @page_visible ->
          assign(socket, :visit_started, now())

        @page_hidden ->
          socket
          |> assign(:visit_started, nil)
          |> assign(:milliseconds_spent, calculate_total_milliseconds_spend(assigns))
      end
      |> assign(:visibility, current_visibility)

    {:noreply, new_socket}
  end

  @doc """
  Callback running during LiveView termination

  Calculate total time spent based on data assigned in #on_mount/4

  Saves time spent and user session data to the database.
  """
  def on_terminate(%{view: view, assigns: assigns} = socket) do
    %{user_agent: user_agent, session_id: session_id, path: path} = assigns

    Monitoring.track_user_activity(%{
      view: "#{view}",
      session_id: session_id,
      path: path,
      seconds_spent: Kernel.trunc(calculate_total_milliseconds_spend(assigns) / 1000),
      metadata: %{user_agent: user_agent}
    })
    |> IO.inspect()

    socket
  end

  @doc """
  Accept socket and image url and assigns url path to the socket.
  """

  def assign_page_path(socket, uri) do
    %{path: path} = URI.parse(uri)

    assign(socket, :path, path)
  end

  @doc """
  Function is responsible for time spent calculations. Based on data assigned in #mount/4

  Applied in two cases:
  1. When calculate total time spent
  2. When calculate intermediate time spent, when visibility state changed.

  Current precision is millisecond.
  It's mean that we are able to track sessions precisely with precision 1 s.
  """
  def calculate_total_milliseconds_spend(%{visit_started: visit_started, milliseconds_spent: milliseconds_spent}) do
    milliseconds_spent + NaiveDateTime.diff(now(), visit_started, @time_calculation_precision)
  end

  defp now(), do: NaiveDateTime.utc_now()
end
