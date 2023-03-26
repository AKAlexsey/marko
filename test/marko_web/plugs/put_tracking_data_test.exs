defmodule MarkoWeb.Plugs.PutTrackingDataTest do
  use MarkoWeb.ConnCase, async: false

  alias MarkoWeb.Plugs.PutTrackingData

  describe "#call/2" do
    setup do
      user_agent = "Firefox"

      conn =
        Phoenix.ConnTest.build_conn()
        |> init_test_session([])
        |> put_req_header("user-agent", user_agent)

      {:ok, conn: conn, user_agent: user_agent}
    end

    test "Fetch user_agent from Plug.Conn structure and put it inside the Plug.Conn session",
         %{conn: conn, user_agent: user_agent} do
      conn = struct(conn, %{user_agent: user_agent})

      result_conn = PutTrackingData.call(conn, [])

      assert %{"user_agent" => ^user_agent} = get_session(result_conn)
    end
  end
end
