defmodule MarkoWeb.ActivityController do
  use MarkoWeb, :controller

  alias Marko.Monitoring

  def index(conn, _params) do
    activities = Monitoring.index_page_activities([:session])
    render(conn, :index, activities: activities)
  end

  def show(conn, %{"id" => id}) do
    activity = Monitoring.get_activity!(id)
    render(conn, :show, activity: activity)
  end

  def delete(conn, %{"id" => id}) do
    activity = Monitoring.get_activity!(id)
    {:ok, _activity} = Monitoring.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: ~p"/activities")
  end
end
