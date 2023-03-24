defmodule MarkoWeb.SessionController do
  use MarkoWeb, :controller

  alias Marko.Monitoring
  alias Marko.Monitoring.Session

  def index(conn, _params) do
    sessions = Monitoring.list_sessions()
    render(conn, :index, sessions: sessions)
  end

  def show(conn, %{"id" => id}) do
    sessions = Monitoring.get_sessions!(id)
    activities = Monitoring.get_activities_for_session(id)
    render(conn, :show, sessions: sessions, activities: activities)
  end

  def delete(conn, %{"id" => id}) do
    sessions = Monitoring.get_sessions!(id)
    {:ok, _sessions} = Monitoring.delete_sessions(sessions)

    conn
    |> put_flash(:info, "Session deleted successfully.")
    |> redirect(to: ~p"/sessions")
  end
end
