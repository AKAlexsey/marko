defmodule MarkoWeb.Plugs.PutSessionTest do
  use MarkoWeb.ConnCase, async: false

  alias Marko.Monitoring.Session
  alias Marko.Repo
  alias MarkoWeb.Plugs.PutSession

  import Marko.MonitoringFixtures

  describe "#call/2" do
    setup do
      conn =
        Phoenix.ConnTest.build_conn()
        |> struct(%{secret_key_base: "secret_key_base"})
        |> init_test_session([])

      {:ok, conn: conn, session_cookie_name: PutSession.session_cookie_name()}
    end

    test "Finds session record by public_hash_id assigned in cookies. Put session ID into conn session.",
         %{conn: conn, session_cookie_name: session_cookie_name} do
      %{id: session_id, public_hash_id: public_hash_id} = sessions_fixture()

      cookie_value =
        Plug.Crypto.sign(
          conn.secret_key_base,
          "#{session_cookie_name}_cookie",
          %{id: public_hash_id},
          keys: Plug.Keys,
          max_age: 86400
        )

      conn =
        conn
        |> put_req_cookie(session_cookie_name, cookie_value)
        |> fetch_cookies(signed: [session_cookie_name])

      result_conn = PutSession.call(conn, [])

      assert %{"session_id" => session_id} == get_session(result_conn)

      assert %Plug.Conn{cookies: %{^session_cookie_name => %{id: ^public_hash_id}}} =
               fetch_cookies(result_conn, signed: [session_cookie_name])
    end

    test "Creates new session and assign it to the conn cookie and session", %{
      conn: conn,
      session_cookie_name: session_cookie_name
    } do
      sessions_count = Repo.aggregate(Session, :count, :id)

      result_conn = PutSession.call(conn, [])

      assert sessions_count + 1 == Repo.aggregate(Session, :count, :id)

      %{cookies: %{^session_cookie_name => value}} =
        fetch_cookies(result_conn, signed: [session_cookie_name])

      assert {:ok, %{id: public_hash_id}} =
               Plug.Crypto.verify(conn.secret_key_base, "#{session_cookie_name}_cookie", value,
                 keys: Plug.Keys
               )

      assert %{id: session_id} = Repo.get_by(Session, public_hash_id: public_hash_id)

      assert %{"session_id" => session_id} == get_session(result_conn)
    end
  end
end
