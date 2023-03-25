defmodule MarkoWeb.Tracking.TrackPagesVisitedTest do
  use Marko.DataCase, async: false

  alias MarkoWeb.Tracking.TrackPagesVisited

  alias Marko.Monitoring.Activity

  import Marko.MonitoringFixtures
  import Phoenix.Component, only: [assign: 3]

  describe "#on_mount/4" do
    test "Fetches data from user session. Assigns necessary for time tracking data to socket." do
      session_id = 23
      user_agent = "Test chromium agent"
      session = %{"session_id" => session_id, "user_agent" => user_agent}

      assert {:cont, %Phoenix.LiveView.Socket{assigns: %{}}} ==
               TrackPagesVisited.on_mount(:activity_tracking, %{}, session, socket_fixture())
    end
  end

  describe "#visibility_changed/2" do
    test "Returns given socket if visibility state not changed" do
    end

    test "Calculates ans assigns time spend if page become hidden" do
    end

    test "Assigns visit start datetime if page become visible" do
    end
  end

  describe "#on_terminate/1" do

    setup do
      {:ok, pid} = Marko.Monitoring.SessionTrackingWorker.start_link(%{})

      on_exit(fn ->
        Process.exit(pid, :normal)
      end)
      :ok
    end

    test "Send tracking data to the Monitoring system." do
      %{id: session_id} = sessions_fixture()

      user_agent = "Test chromium agent"
      session = %{"session_id" => session_id, "user_agent" => user_agent}

      milliseconds_spent = 1900
      path = "/page_test"
      view = "PageTest"

      socket = socket_fixture(%{view: view, milliseconds_spent: milliseconds_spent, path: path, session_id: session_id, milliseconds_spent: milliseconds_spent, visit_started: NaiveDateTime.utc_now(), user_agent: user_agent})
      :timer.sleep(400)

      assert socket == TrackPagesVisited.on_terminate(socket)

      assert %Activity{session_id: ^session_id, path: ^path, view: ^view, seconds_spent: 1, metadata: ^user_agent} =
               Repo.get_by(Activity, %{session_id: session_id})

    end
  end

  describe "#assign_page_path/2" do
    test "Parses given URI and assign it's path to the socket" do
    end
  end

  describe "#calculate_total_milliseconds_spend/1" do
    test "Calculates datetime based on assigned data" do
      milliseconds_spent = 1800

      assigns = %{
          visit_started: NaiveDateTime.utc_now(),
          milliseconds_spent: milliseconds_spent
        }

      :timer.sleep(500)

      assert 2 = Kernel.trunc(TrackPagesVisited.calculate_total_milliseconds_spend(assigns) / 1000)
    end
  end

  def socket_fixture(assigns \\ %{}) do
    struct(%Phoenix.LiveView.Socket{}, %{assigns: assigns})
  end
end
