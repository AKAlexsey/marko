defmodule MarkoWeb.SessionControllerTest do
  use MarkoWeb.ConnCase

  import Marko.MonitoringFixtures

  describe "index" do
    test "lists all sessions", %{conn: conn} do
      conn = get(conn, ~p"/sessions")
      assert html_response(conn, 200) =~ "Listing Session"
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
