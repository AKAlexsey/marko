defmodule MarkoWeb.SessionController do
  use MarkoWeb, :controller

  alias Marko.Monitoring
  alias Marko.Monitoring.Session

  def index(conn, _params) do
    sessions = Monitoring.list_sessions()
    render(conn, :index, sessions: sessions)
  end

  def new(conn, _params) do
    changeset = Monitoring.change_sessions(%Session{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"sessions" => sessions_params}) do
    case Monitoring.create_sessions(sessions_params) do
      {:ok, sessions} ->
        conn
        |> put_flash(:info, "Session created successfully.")
        |> redirect(to: ~p"/sessions/#{sessions}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sessions = Monitoring.get_sessions!(id)
    render(conn, :show, sessions: sessions)
  end

  def edit(conn, %{"id" => id}) do
    sessions = Monitoring.get_sessions!(id)
    changeset = Monitoring.change_sessions(sessions)
    render(conn, :edit, sessions: sessions, changeset: changeset)
  end

  def update(conn, %{"id" => id, "sessions" => sessions_params}) do
    sessions = Monitoring.get_sessions!(id)

    case Monitoring.update_sessions(sessions, sessions_params) do
      {:ok, sessions} ->
        conn
        |> put_flash(:info, "Session updated successfully.")
        |> redirect(to: ~p"/sessions/#{sessions}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, sessions: sessions, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sessions = Monitoring.get_sessions!(id)
    {:ok, _sessions} = Monitoring.delete_sessions(sessions)

    conn
    |> put_flash(:info, "Session deleted successfully.")
    |> redirect(to: ~p"/sessions")
  end
end
