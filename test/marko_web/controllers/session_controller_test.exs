defmodule MarkoWeb.SessionControllerTest do
  use MarkoWeb.ConnCase

  import Marko.MonitoringFixtures

  @create_attrs %{public_hash_id: "some public_hash_id"}
  @update_attrs %{public_hash_id: "some updated public_hash_id"}
  @invalid_attrs %{public_hash_id: nil}

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      conn = get(conn, ~p"/sessions")
      assert html_response(conn, 200) =~ "Listing Session"
    end
  end

  describe "new sessions" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/sessions/new")
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "create sessions" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/sessions", sessions: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/sessions/#{id}"

      conn = get(conn, ~p"/sessions/#{id}")
      assert html_response(conn, 200) =~ "Session #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/sessions", sessions: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Session"
    end
  end

  describe "edit sessions" do
    setup [:create_sessions]

    test "renders form for editing chosen sessions", %{conn: conn, sessions: sessions} do
      conn = get(conn, ~p"/sessions/#{sessions}/edit")
      assert html_response(conn, 200) =~ "Edit Session"
    end
  end

  describe "update sessions" do
    setup [:create_sessions]

    test "redirects when data is valid", %{conn: conn, sessions: sessions} do
      conn = put(conn, ~p"/sessions/#{sessions}", sessions: @update_attrs)
      assert redirected_to(conn) == ~p"/sessions/#{sessions}"

      conn = get(conn, ~p"/sessions/#{sessions}")
      assert html_response(conn, 200) =~ "some updated public_hash_id"
    end

    test "renders errors when data is invalid", %{conn: conn, sessions: sessions} do
      conn = put(conn, ~p"/sessions/#{sessions}", sessions: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Session"
    end
  end

  describe "delete sessions" do
    setup [:create_sessions]

    test "deletes chosen sessions", %{conn: conn, sessions: sessions} do
      conn = delete(conn, ~p"/sessions/#{sessions}")
      assert redirected_to(conn) == ~p"/sessions"

      assert_error_sent 404, fn ->
        get(conn, ~p"/sessions/#{sessions}")
      end
    end
  end

  defp create_sessions(_) do
    sessions = sessions_fixture()
    %{sessions: sessions}
  end
end
